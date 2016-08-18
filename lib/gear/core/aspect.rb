module Gear::Core
  # An Aspects is used by systems as a matcher against entities, to check if a system is
  # interested in an entity. Aspects define what sort of component types an entity must
  # possess, or not possess.
  # 
  # This creates an aspect where an entity must possess A and B and C:
  # Aspect.get_aspect_for_all(A.class, B.class, C.class)
  # 
  # This creates an aspect where an entity must possess A and B and C, but must not possess U or V.
  # Aspect.get_aspect_for_all(A.class, B.class, C.class).exclude(U.class, V.class)
  # 
  # This creates an aspect where an entity must possess A and B and C, but must not possess U or V, but must possess one of X or Y or Z.
  # Aspect.get_aspect_for_all(A.class, B.class, C.class).exclude(U.class, V.class).one(X.class, Y.class, Z.class)
  #
  # You can create and compose aspects in many ways:
  # Aspect.get_empty().one(X.class, Y.class, Z.class).all(A.class, B.class, C.class).exclude(U.class, V.class)
  # is the same as:
  # Aspect.get_aspect_for_all(A.class, B.class, C.class).exclude(U.class, V.class).one(X.class, Y.class, Z.class)
  class Aspect
    attr_reader :all_set, :exclude_set, :one_set

    def initialize
      @all_set = Array.new
      @exclude_set = Array.new
      @one_set = Array.new
    end

    def array_from_argument_list(arg_list)
      raise Gear::Errors::LeastArgument.new "must have at least 1 argument" if arg_list.length <= 0

      arg_list = arg_list[0] if arg_list.length == 1 && arg_list[0].is_a?(Array)

      arg_list
    end

    # Add a bunch of component classes into a set
    #
    # @param component_classes array of component classes to be added to set
    # @param set the set to be operated on
    # @return itself to be chained
    def add_component_classes_to_set(component_classes, set)
      component_classes.each do |component_class|
        raise Gear::Errors::InvalidComponentSubclass.new "#{component_class.to_s} is not a subclass of Component" if !component_class.is_a?(Class) || !(component_class <= Component)

        set << ComponentType.index_for(component_class)
      end 

      self
    end

    # Returns an aspect where an entity must possess all of the specified component types.
    #
    # @param component_classes required component classes
    # @return an aspect that can be matched against entities
    def all(*component_classes)
      add_component_classes_to_set array_from_argument_list(component_classes), @all_set
    end

    # Excludes all of the specified component types from the aspect. A system will not be
    # interested in an entity that possesses one of the specified exclude component types.
    # 
    # @param component_classes component classes to exclude
    # @return an aspect that can be matched against entities
    def exclude(*component_classes)
      add_component_classes_to_set array_from_argument_list(component_classes), @exclude_set
    end

    # Returns an aspect where an entity must possess one of the specified component types.
    #
    # @param component_classes one of the component classes the entity must possess
    # @return an aspect that can be matched against entities
    def one(*component_classes)
      add_component_classes_to_set array_from_argument_list(component_classes), @one_set
    end

    ### Factories
    def self.new_for_all(*component_classes)
      Aspect.new.all component_classes
    end

    def self.new_for_one(*component_classes)
      Aspect.new.one component_classes
    end

    def self.new_empty
      Aspect.new
    end
  end
end
