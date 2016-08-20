require 'spec_helper'

describe Gear::Core::GroupManager do

  it 'should work' do
    gm = Gear::Core::GroupManager.new
    expect(gm.entities_by_group).to be {}
    expect(gm.groups_by_entity).to be {}

    g = Gear::Core::Gamebox.new
    e1 = Gear::Core::Entity.new g
    e2 = Gear::Core::Entity.new g
    g1 = :group1
    g2 = :group2

    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be false
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array []
    expect(gm.get_entities(g2)).to match_array []
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array []

    gm.add(e1, g1)
    expect(gm.any_group?(e1)).to be true
    expect(gm.any_group?(e2)).to be false
    expect(gm.in_group?(e1, g1)).to be true
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array [e1]
    expect(gm.get_entities(g2)).to match_array []
    expect(gm.get_groups(e1)).to match_array [g1]
    expect(gm.get_groups(e2)).to match_array []

    gm.add(e1, g2)
    expect(gm.any_group?(e1)).to be true
    expect(gm.any_group?(e2)).to be false
    expect(gm.in_group?(e1, g1)).to be true
    expect(gm.in_group?(e1, g2)).to be true
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array [e1]
    expect(gm.get_entities(g2)).to match_array [e1]
    expect(gm.get_groups(e1)).to match_array [g1, g2]
    expect(gm.get_groups(e2)).to match_array []

    gm.add(e2, g1)
    expect(gm.any_group?(e1)).to be true
    expect(gm.any_group?(e2)).to be true
    expect(gm.in_group?(e1, g1)).to be true
    expect(gm.in_group?(e1, g2)).to be true
    expect(gm.in_group?(e2, g1)).to be true
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array [e1, e2]
    expect(gm.get_entities(g2)).to match_array [e1]
    expect(gm.get_groups(e1)).to match_array [g1, g2]
    expect(gm.get_groups(e2)).to match_array [g1]

    gm.deleted(e1)
    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be true
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be true
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array [e2]
    expect(gm.get_entities(g2)).to match_array []
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array [g1]

    gm.add(e2, g2)
    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be true
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be true
    expect(gm.in_group?(e2, g2)).to be true
    expect(gm.get_entities(g1)).to match_array [e2]
    expect(gm.get_entities(g2)).to match_array [e2]
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array [g1, g2]

    gm.remove(e2, g1)
    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be true
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be true
    expect(gm.get_entities(g1)).to match_array []
    expect(gm.get_entities(g2)).to match_array [e2]
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array [g2]

    gm.remove(e2, g2)
    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be false
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array []
    expect(gm.get_entities(g2)).to match_array []
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array []
  
    gm.remove(e2, '')
    expect(gm.any_group?(e1)).to be false
    expect(gm.any_group?(e2)).to be false
    expect(gm.any_group?(3)).to be false
    expect(gm.in_group?(e1, g1)).to be false
    expect(gm.in_group?(e1, g2)).to be false
    expect(gm.in_group?(e2, g1)).to be false
    expect(gm.in_group?(e2, g2)).to be false
    expect(gm.get_entities(g1)).to match_array []
    expect(gm.get_entities(g2)).to match_array []
    expect(gm.get_groups(e1)).to match_array []
    expect(gm.get_groups(e2)).to match_array []
  end

end