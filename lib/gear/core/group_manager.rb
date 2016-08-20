module Gear::Core

  # If you need to group your entities together, e.g. tanks going into "units" group or explosions into "effects",
  # then use this manager. You must retrieve it using world instance.
  # A entity can be assigned to more than one group.
  class GroupManager < Manager
    
    attr_accessor :entities_by_group, :groups_by_entity

    def initialize
      @entities_by_group = {}
      @groups_by_entity = {}
    end

    def deleted(e)
      remove_from_all_groups(e)
    end

    
    # e Entity, group String
    def add(e, group)
      get_entities(group) << e
      get_groups(e) << group
    end

    def remove(e, group)
      get_entities(group).delete(e)
      get_groups(e).delete(group)
    end

    def remove_from_all_groups(e)
      if (groups = @groups_by_entity.delete(e))
        groups.each{ |group| remove(e, group) }
      end
    end

    def get_entities(group)
      @entities_by_group[group] ||= []
    end

    def get_groups(e)
      @groups_by_entity[e] ||= []
    end

    def any_group?(e)
      !get_groups(e).empty?
    end

    def in_group?(e, group)
      get_groups(e).include?(group)
    end
  end
end
