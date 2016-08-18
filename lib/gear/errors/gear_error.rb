module Gear
  module Errors
    class GearError < StandardError
      def compose_message(key, opt)
        "\nmessage:\n  #{problem(opt)}"+
        "\nsummary:\n  #{summary(opt)}"+
        "\nresolution:\n  #{resolution(opt)}"
      end

      def problem(opt)
        opt[:problem]
      end

      def summary(opt)
        opt[:summary] || " "
      end

      def resolution(opt)
        opt[:resolution]
      end
    end
  end
end