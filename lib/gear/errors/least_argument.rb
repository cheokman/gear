module Gear
  module Errors
    class LeastArgument < GearError
      def initialize(message)
        super(
          compose_message("least_argument", 
            {problem: "Least Argument", summary: "", resolution: message})
        )
      end

      
    end
  end
end