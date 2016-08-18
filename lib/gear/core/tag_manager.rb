module Gear
  module Core

    # If you need to tag any entity, use this. A typical usage would be to tag
    # entities such as "PLAYER", "BOSS" or something that is very unique.
    class TagManager < Manager
      attr_accessor :entity_by_tag

      def initialize
        @entity_by_tag = {}
      end

      def deleted(e)
        @entity_by_tag.delete_if { |k, v| v == e }
      end

      def register(tag, e)
        @entity_by_tag[tag] = e
      end

      def unregister(tag)
        @entity_by_tag.delete(tag)
      end

      def registered?(tag)
        @entity_by_tag.has_key?(tag)
      end

      def get_entity(tag)
        @entity_by_tag[tag]
      end

      def get_registered_tags
        @entity_by_tag.keys
      end
    end
  end
end
