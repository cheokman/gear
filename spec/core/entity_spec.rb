require 'spec_helper'

describe Gear::Core::Entity do

  before :each do
    component_manager = double("component_manager",
      add_component: "add_component",
      remove_component: "remove_component"
    )

    gamebox = double('gamebox',
      entity_manager: "entity_manager stub",
      component_manager: component_manager
    )

    @entity = Gear::Core::Entity.new gamebox
  end

  it "have a random UUID by default" do
    expect(@entity.uuid).not_to be_nil
  end

  context "#to_s" do
    it "generate string in format Entity[id]" do
      expect(@entity.to_s).to eq "Entity[#{@entity.id}]"
    end
  end

  context "#add_component" do
    it "only accept Component objects as first argument" do
      expect { @entity.add_component(Array.new) }.to raise_error(Gear::Errors::GearError)
      expect { @entity.add_component(Gear::Core::Component.new) }.to_not raise_error
    end

    it "imply second argument (component type) from first argument if second argument is ommited" do
      component = Gear::Core::Component.new
      expect(Gear::Core::ComponentType).to receive(:type_for).with component.class

      @entity.add_component component
    end

    it "call @component_manager.add_component" do
      component = Gear::Core::Component.new
      component_type = Gear::Core::ComponentType.type_for component.class

      expect(@entity.instance_variable_get(:@component_manager)).to receive(:add_component).with @entity, component_type, component 

      @entity.add_component component, component_type 
    end

    it "return itself" do
      expect(@entity.add_component(Gear::Core::Component.new)).to eq @entity
    end
  end

  context "#remove_component" do
    it "only accept Component or ComponentType objects as argument" do
      expect { @entity.remove_component(Array.new) }.to raise_error(Gear::Errors::GearError)
      expect { @entity.remove_component(Gear::Core::Component.new) }.to_not raise_error
      expect { @entity.remove_component(Gear::Core::ComponentType.type_for Gear::Core::Component.new.class) }.to_not raise_error
    end

    it "call @component_manager.remove_component" do
      component = Gear::Core::Component.new
      component_type = Gear::Core::ComponentType.type_for component.class

      expect(@entity.instance_variable_get(:@component_manager)).to receive(:remove_component).with @entity, component_type

      @entity.remove_component component
    end

    it "return itself" do
      expect(@entity.remove_component(Gear::Core::Component.new)).to eq @entity
    end
  end
  
end
