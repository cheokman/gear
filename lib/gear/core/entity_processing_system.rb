module Gear::Core
  # A typical entity system. Use this when you need to process entities possessing the
  # provided component types.
  class EntityProcessingSystem < System
    def process_entities(entities)
      entities.each { |entity| process_entity entity }
    end

    def check_processing
      true
    end
  end
end
