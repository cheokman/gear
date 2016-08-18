require 'spec_helper'

describe Gear::Core::EntityManager do

  it "can have diff gameboxs" do
    em = Gear::Core::EntityManager.new
    m = Gear::Core::Manager.new
    m.gamebox = Gear::Core::Gamebox.new
    em.gamebox = Gear::Core::Gamebox.new
    expect(em.gamebox).not_to be_eql m.gamebox
  end


  it 'should work' do
    em = Gear::Core::EntityManager.new
    expect(em.disabled).to be {}
    expect(em.active).to be_equal 0
    expect(em.created).to be_equal 0
    expect(em.deleted).to be_equal 0
    expect(em.added).to be_equal 0

    em.gamebox = Gear::Core::Gamebox.new    
    e1 = em.create_entity
    e2 = em.create_entity
    expect(em.get_entity(e1.id)).to be_nil
    expect(em.get_entity(e2.id)).to be_nil

    em.added(e1)
    expect(em.active).to be_equal 1
    expect(em.created).to be_equal 2
    expect(em.deleted).to be_equal 0
    expect(em.added).to be_equal 1
    expect(em.get_entity(e1.id)).to be_equal e1

    expect(em).to be_active(e1.id)
    expect(em).not_to be_active(e2.id)

    expect(em).to be_is_enabled(e1.id)
    expect(em).to be_is_enabled(e2.id)

    em.disabled(e2)
    expect(em).not_to be_is_enabled(e2.id)
    expect(em.active).to be_equal 1
    expect(em.created).to be_equal 2
    expect(em.deleted).to be_equal 0
    expect(em.added).to be_equal 1
    expect(em.get_entity(e1.id)).to be_equal e1

    em.added(e2)
    expect(em.active).to be_equal 2
    expect(em.created).to be_equal 2
    expect(em.deleted).to be_equal 0
    expect(em.added).to be_equal 2
    expect(em.get_entity(e1.id)).to be_equal e1
    expect(em.get_entity(e2.id)).to be_equal e2

    em.deleted(e1)
    expect(em.active).to be_equal 1
    expect(em.created).to be_equal 2
    expect(em.deleted).to be_equal 1
    expect(em.added).to be_equal 2
    expect(em.get_entity(e1.id)).to be_equal nil
    expect(em.get_entity(e2.id)).to be_equal e2
  end

end
