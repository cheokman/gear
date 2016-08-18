
module Gear::Core
  class System < EntityObserver
    attr_reader :active_entities, :aspect, :system_index
    attr_reader :all_set, :exclude_set, :one_set
    attr_accessor :gamebox, :passive
    attr_reader :dummy

    def initialize(aspect)
      @active_entities = Bag.new

      @aspect = aspect
      @all_set = aspect.all_set
      @exclude_set = aspect.exclude_set
      @one_set = aspect.one_set

      @system_index = SystemIndexManager.index_for self.class

      # This system can't possibly be interested in any entity, so it must be "dummy"
      @dummy = @all_set.empty? && @one_set.empty?
    end

    # Called before processing of entities begins
    def pre_process_entities
    end

    def process
      if check_processing
        pre_process_entities
        process_entities @active_entities
        post_process_entities
      end
    end

    # Called after the processing of entities ends
    def post_process_entities 
    end

    # Any implementing entity system must implement this method and the logic
    # to process the given entities of the system.
    # 
    # @param entities the entities this system contains.
    def process_entities(entities)
      raise "implement me in subclass"
    end

    # Check if this system can process
    #
    # @return true if the system should be processed, false if not.
    def check_processing
      raise "implement me in subclass" 
    end

    # Called if the system has received a entity it is interested in, e.g. created or a component was added to it.
    # @param e the entity that was added to this system.
    #
    def inserted(entity); end

    # Called if a entity was removed from this system, e.g. deleted or had one of it's components removed.
    #
    # @param e the entity that was removed from this system.
    def removed(entity); end


    def check(entity)
      return if @dummy

      component_class_indices = entity.component_class_indices
      interested = true # possibly interested, let's try to prove it wrong.

      # Check if the entity possesses ALL of the components defined in the aspect
      interested = (@all_set.uniq - component_class_indices.uniq).empty?

      # Then check if the entity possesses ANY of the exclusion components, if it does then the system is not interested.
      interested &&= (@exclude_set & component_class_indices).empty?

      # Then check if the entity possesses ANY of the components in the oneSet. If so, the system is interested.
      interested &&= @one_set.empty? || !(@one_set & component_class_indices).empty?

      puts "check #{entity} #{entity.component_class_indices} against #{self} [all: #{@all_set}, exclude: #{@exclude_set}, one: #{@one_set}] => #{interested}" if @gamebox.debug

      contains = entity.system_class_indices.include?(self.system_index)
      insert_to_system(entity) if interested && !contains
      remove_from_system(entity) if !interested && contains
    end

    def remove_from_system(entity)
      @active_entities.remove entity
      entity.system_class_indices.delete @system_index
      removed entity
      puts "Removed #{entity} from #{self}" if @world.debug
    end

    def insert_to_system(entity)
      @active_entities.add entity
      entity.system_class_indices << @system_index
      inserted entity 
    end

    def added(entity)
      check entity 
    end

    def changed(entity)
      check entity 
    end

    def deleted(entity)
      remove_from_system entity if entity.system_class_indices.include? @system_index
    end

    def disabled(entity)
      deleted entity 
    end

    def enabled(entity)
      check entity
    end
  end


  # Used to generate a unique bit for each system.
  # Only used internally in EntitySystem.
  class SystemIndexManager
    @@next_index = 0
    @@indices = Hash.new

    def self.index_for(klass)
      index = @@indices[klass] 
      unless index
        index = @@next_index
        @@next_index += 1

        @@indices[klass] = index
      end
      index
    end
  end
end