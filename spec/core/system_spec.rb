require 'spec_helper'

describe Gear::Core::System do
  it "inherits from EntityObserver" do
    described_class < Gear::Core::EntityObserver 
  end

  describe "#initialize" do
    it "clone all given aspect's bitsets" do
      @aspect = Gear::Core::Aspect.new_for_all Gear::Core::Component
      @system = Gear::Core::System.new @aspect

      expect(@system.all_set).to be @aspect.all_set
      expect(@system.exclude_set).to be @aspect.exclude_set
      expect(@system.one_set).to be @aspect.one_set
    end
  end
end