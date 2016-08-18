module Gear::Core
  class ComponentType 
    private_class_method :new

    @@next_index = 0
    @@component_types = Hash.new

    attr_reader :type, :index

    def initialize(type)
      @index = @@next_index
      @@next_index += 1 

      @type = type
    end

    #
    # TODO: refactor Gear::Errors::GearError
    #
    def self.type_for(klass)
      raise Gear::Errors::GearError.new "#{klass.to_s} is not a subclass of Artemis::Component" if !klass.is_a?(Class) ||
        !(klass <= Component)

      component_type = @@component_types[klass]
      if (component_type == nil)
        component_type = new klass
        @@component_types[klass] = component_type
      end

      component_type 
    end

    def to_s
      "ComponentType[#{ type.to_s }](#{ index })"
    end

    def self.index_for(klass)
      type_for(klass).index
    end

    def self.next_index
      @@next_index
    end
  end

end
