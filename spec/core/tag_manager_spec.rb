require 'spec_helper'

describe Gear::Core::TagManager do

  it "should work" do
    tm = Gear::Core::TagManager.new
    expect(tm.entity_by_tag).to be {}

    g = Gear::Core::Gamebox.new
    e1 = Gear::Core::Entity.new g
    e2 = Gear::Core::Entity.new g
    t1 = :tag1
    t2 = :tag2

    expect(tm.registered?(t1)).to be false
    expect(tm.registered?(t2)).to be false
    expect(tm.get_entity(t1)).to be nil
    expect(tm.get_entity(t2)).to be nil
    expect(tm.get_registered_tags).to match_array []

    tm.register(t1, e1)
    expect(tm.registered?(t1)).to be true
    expect(tm.registered?(t2)).to be false
    expect(tm.get_entity(t1)).to be e1
    expect(tm.get_entity(t2)).to be nil
    expect(tm.get_registered_tags).to match_array [t1]

    tm.register(t2, e1)
    expect(tm.registered?(t1)).to be true
    expect(tm.registered?(t2)).to be true
    expect(tm.get_entity(t1)).to be e1
    expect(tm.get_entity(t2)).to be e1
    expect(tm.get_registered_tags).to match_array [t1, t2]
    expect(tm.get_entity(t1)).to be e1
    expect(tm.get_entity(t2)).to be e1

    tm.unregister(t2)
    expect(tm.registered?(t1)).to be true
    expect(tm.registered?(t2)).to be false
    expect(tm.get_entity(t1)).to be e1
    expect(tm.get_entity(t2)).to be nil
    expect(tm.get_registered_tags).to match_array [t1]

    tm.deleted(e1)
    expect(tm.registered?(t1)).to be false
    expect(tm.registered?(t2)).to be false
    expect(tm.get_entity(t1)).to be nil
    expect(tm.get_entity(t2)).to be nil
    expect(tm.get_registered_tags).to match_array []
  end

end