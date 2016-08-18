module Gear::Core
  class EntityManager < Manager
       attr_accessor :entities, :disabled, :active, :added, :created, :deleted

    def initialize
      @entities = Bag.new
      @disabled = {}
      @active = @added = @created = @deleted = 0
    end

    def create_entity(*components)
      e = Entity.new(@gamebox)
      e.add_components(*components)
      @created += 1
      e
    end

    def added(e = nil)
      if e.nil?
        @added
      else
        @active += 1
        @added += 1
        @entities.add(e)
      end
    end

    def disabled(e = nil)
      if e.nil?
        @disabled
      else
        @disabled[e.id] = true
      end
    end

    def enabled(e)
      !!@disabled.delete(e.id)
    end

    def deleted(e = nil)
      if e.nil?
        @deleted
      else
        @entities.remove(e)
        puts "remove #{e} from EM's @entities list"# if @gamebox.debug
        @disabled.delete(e.id)
        @active -= 1
        @deleted += 1
      end
    end

    def active?(entity_id)
      !!@entities[entity_id]
    end

    def is_enabled?(entity_id)
      !disabled[entity_id]
    end

    def get_entity(entity_id)
      @entities[entity_id]
    end
  end
end