module Gear
  module Errors
    class InvalidComponentSubclass < GearError
      def initialize(message)
        super(
          compose_message("invalid_component_subclass", 
            {problem: "Invalid Component Subclass", summary: "", resolution: message})
        )
      end
    end
  end
end