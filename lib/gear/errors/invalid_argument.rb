module Gear
  module Errors
    class InvalidArgument < GearError
      def initialize(problem, summary, resolution)
        super(
          compose("invalid_argument", 
            {problem: problem, summary: summary, resolution: resolution)
        )
      end

      
    end
  end
end