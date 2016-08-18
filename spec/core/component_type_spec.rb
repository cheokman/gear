require 'spec_helper'

describe Gear::Core::ComponentType do
  before do
    class ComponentOne < Gear::Core::Component
    end 

    class ComponentTwo < Gear::Core::Component
    end 
  end

  it "cannot instantiate from the outside (.new is private)" do
    expect(described_class).to_not respond_to :new 
  end

  context ".type_for" do
    it "only accept subclasses of Component as argument" do
      expect { described_class.type_for(Array) }.to raise_error(Gear::Errors::GearError)
      expect { described_class.type_for(Array.new) }.to raise_error(Gear::Errors::GearError)
      expect { described_class.type_for(ComponentOne.new) }.to raise_error(Gear::Errors::GearError)

      expect { described_class.type_for(ComponentOne) }.not_to raise_error
    end

    context "return a ComponentType" do
      before do
        @component_type = described_class.type_for(ComponentOne)
      end

      it "is not nil" do
        expect(@component_type).to_not be_nil
      end

      it "has type equal to given parameter" do
        expect(@component_type.type).to eq ComponentOne
      end

      it "has index less than #{described_class.to_s}.next_index exactly 1" do
        component_type_two = described_class.type_for(ComponentTwo)
        expect(component_type_two.index).to eq described_class.next_index - 1
      end

      it "always return a unique object for each given Component subclass" do
        component_type_one_1 = described_class.type_for(ComponentOne)
        component_type_two_1 = described_class.type_for(ComponentTwo)

        component_type_one_2 = described_class.type_for(ComponentOne)
        component_type_two_2 = described_class.type_for(ComponentTwo)

        expect(component_type_one_1).to eq component_type_one_2
        expect(component_type_two_1).to eq component_type_two_2

        expect(component_type_one_1).to_not eq component_type_two_1
      end
    end
  end

  context "#to_s" do
    it "return a string with format: 'ComponentType[type_name](index)'" do
      component_type = described_class.type_for(ComponentOne)
      expect(component_type.to_s).to eq "ComponentType[#{ component_type.type.to_s }](#{ component_type.index })" 
    end
  end
end
