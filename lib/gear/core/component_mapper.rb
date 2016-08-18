module Gear::Core
  # High performance component retrieval from entities. Use this wherever you
  # need to retrieve components from entities often and fast.
  class ComponentMapper
    attr_reader :component_type, :component_class, :components

    def initialize(component_class, gamebox)
      @component_type = ComponentType.type_for component_class
      @component_class = component_class 

      @components = gamebox.component_manager.get_components_by_type @component_type 
    end

    # Fast but unsafe retrieval of a component for this entity.
    # No bounding checks, so this could throw an ArrayIndexOutOfBoundsExeption,
    # however in most scenarios you already know the entity possesses this component.
    # 
    # @param e the entity that should possess the component
    # @return the instance of the component
    def get(entity)
      @components[entity.id]  
    end
  end
end
