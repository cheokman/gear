module Gear::Core
  class Entity
    attr_reader :gamebox, :uuid, :system_class_indices, :component_class_indices
    attr_accessor :name

    BIG_N = 1_000_000
    def gen_uuid
      (Time.now.to_f * BIG_N).to_i * BIG_N + rand(BIG_N)
    end

    def initialize(gamebox)
      @gamebox = gamebox
      @entity_manager = gamebox.entity_manager
      @component_manager = gamebox.component_manager
      @system_class_indices = Array.new
      @component_class_indices = Array.new
      @uuid = gen_uuid
    end

    def id
      @uuid
    end

    def to_s
      "Entity[#{id}]"
    end

    # Add the component to this entity
    #
    # @param component to be added
    # @param component_type ComponentType corresponds to component
    #
    # @return this entity for chaining
    def add_component(component, component_type = nil)
      raise Gear::Errors::GearError.new "#{component.to_s} is not an instance of Artemis::Component" if !component.is_a?(Component)

      component_type = ComponentType.type_for component.class unless component_type

      @component_manager.add_component self, component_type, component
      
      self
    end

    def add_components(*components)
      components.each do |component|
        add_component component
      end 
    end

    # Removes the component from this entity
    #
    # @param obj can be either the component to be removed or
    # an ComponentType object
    #
    # @return this entity for chaining
    def remove_component(obj)
      component_type = nil
      if obj.is_a? Component
        component_type = ComponentType.type_for obj.class
      elsif obj.is_a? ComponentType
        component_type = obj
      elsif obj.is_a?(Class) && obj <= Component
        component_type = ComponentType.type_for obj
      end

      if component_type
        @component_manager.remove_component self, component_type
      else
        raise Gear::Errors::GearError.new "#{obj.to_s} is neither a Component object nor ComponentType object nor subclass of Component" 
      end

      self
    end


    # This is the preferred method to use when retrieving a component from a
    # entity. It will provide good performance.
    # But the recommended way to retrieve components from an entity is using
    # the ComponentMapper.
    # 
    # @param type in order to retrieve the component fast you must provide a
    #             ComponentType instance for the expected component.
    # @return
    def get_component(obj)
      component_type = obj if obj.is_a? ComponentType
      component_type = ComponentType.type_for obj if obj.is_a?(Class) && obj <= Component

      if component_type
        return @component_manager.get_component self, component_type 
      else
        raise "#{obj.to_s} is neither a ComponentType object nor an Component subclass"
      end
    end
  end
end