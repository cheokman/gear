require 'spec_helper'

describe Gear::Core::Bag do
  it "work as exepected" do
    b = Gear::Core::Bag.new
    expect(b.size).to be_equal 0

    g = Gear::Core::Gamebox.new
    s = 'abc'
    e = Gear::Core::Entity.new(g)

    b.add(s, 1)
    b.add(e)

    expect(b.size).to be_equal 2
    expect(b.values).to eq([s, e])

    expect(b.remove(3)).to be_equal b
    expect(b.remove(s)).to be_equal b
    expect(b).to eq({e.id => e})
    expect(b.remove(e)).to be_equal e
  end
end