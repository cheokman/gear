require 'spec_helper'

describe Gear::Core::Aspect do
  before :each do
    @aspect = Gear::Core::Aspect.new
  end

  [:all, :exclude, :one].each do |func|
    context "#{func}" do
      it "take a *arg or an array of Component subclasses as argument" do
        expect { @aspect.send func, [1, 2, 3] }.to raise_error(Gear::Errors::InvalidComponentSubclass)

        expect { @aspect.send func, [Gear::Core::Component, Gear::Core::Component] }.to_not raise_error
        expect { @aspect.send func, Gear::Core::Component, Gear::Core::Component }.to_not raise_error
      end

      it "add component indices into set" do
        class Component1 < Gear::Core::Component
        end
        class Component2 < Gear::Core::Component
        end
        class Component3 < Gear::Core::Component
        end

        @aspect.send func, Component1, Component2
        set = @aspect.send("#{func}_set".to_sym)
        expect(set.include?(Gear::Core::ComponentType.index_for Component1)).to be_truthy
        expect(set.include?(Gear::Core::ComponentType.index_for Component2)).to be_truthy
        expect(set.include?(Gear::Core::ComponentType.index_for Component3)).to be_falsy
      end

      it "return itself" do
        expect(@aspect.send(func, Gear::Core::Component)).to eq @aspect
      end
    end
  end

  ### Factories
  context "#new_for_all, #new_for_one" do
    [:all, :one].each do |func|
      it "create and return a new Aspect object" do
        expect(Gear::Core::Aspect.send("new_for_#{func}".to_sym, Gear::Core::Component, Gear::Core::Component)).to be_a Gear::Core::Aspect
      end
    end
  end

end
