require 'spec_helper'

describe Gear::Core::Manager do

  it "have gamebox" do
    g = Gear::Core::Gamebox.new
    m = Gear::Core::Manager.new
    m.gamebox = g
    expect(m.gamebox).to be g
  end

end