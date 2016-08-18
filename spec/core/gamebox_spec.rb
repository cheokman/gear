require 'spec_helper'

describe Gear::Core::Gamebox do

  context 'it all started by creating a new gamebox, and it' do
    before :all do
      @g = Gear::Core::Gamebox.new
      @tm = Gear::Core::TagManager.new
      @tm.gamebox = @g
    end

    it 'must have an entity manager' do
      expect(@g.entity_manager.is_a?(Gear::Core::EntityManager)).to  be_truthy
    end

    it 'must have a component manager' do
      expect(@g.component_manager.is_a?(Gear::Core::ComponentManager)).to be_truthy
    end

    it 'newly added manager should belong to this gamebox' do
      @g.add_manager(@tm)
      expect(@tm.gamebox).to be_equal @g
    end

    it "should get manager from it's class name" do
      @g.add_manager(@tm)
      expect(@g.get_manager(Gear::Core::TagManager)).to be_equal @tm
    end

    it 'can delete an added manager' do
      @g.add_manager(@tm)
      expect(@g.delete_manager(@tm)).to be_truthy
      expect(@g.get_manager(Gear::Core::TagManager)).to be_nil
      expect(@g.delete_manager(@tm)).to be_falsy
    end

    it 'can process observers (managers, systems) with entities' do
      @g.add_manager(@tm)
      e1 = @g.create_entity
      expect(@g.entity_manager.created).to be_equal 1 
      e2 = @g.create_entity
      expect(@g.entity_manager.created).to be_equal 2

      expect(@g.get_entity(e1.id)).to be_nil
      expect(@g.get_entity(e2.id)).to be_nil
      expect(@g.entity_manager).not_to be_active(e1.id)
      expect(@g.entity_manager).not_to be_active(e2.id)

      @g.add_entity(e1)
      expect(@g.get_entity(e1.id)).to be_nil
      expect(@g.entity_manager).not_to be_active(e1.id)
      @g.delete_entity(e2)

      @g.process
      expect(@g.entity_manager.active).to be_equal 0
      expect(@g.entity_manager.deleted).to be_equal 1
    end
  end

end