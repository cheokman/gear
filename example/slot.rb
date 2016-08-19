$:.unshift("#{File.dirname(__FILE__)}/../lib")
require 'gear'

class Slot
  def run
    reels = 3
    symbols = 6
    types = 3
    puts "Hello World! This is a slot game"
    @base_game = Gear::Core::Gamebox.new
    

    @base_game.set_system(RNGSysetm.new).setup

    1.upto(reels) do |i|
      e = @base_game.create_entity
      1.upto(symbols) do |j|
        s = SymbolComponent.new
        s.reel = i
        s.index = j 
        s.type = rand(types)
        e.add_component s
      end
      rng = RandomComponent.new
      rng.num_rng = 1
      e.add_component rng
      e.add_to_gamebox
    end
    process
  end

  def process
    @base_game.process
  end
end

class SymbolComponent < Gear::Core::Component
  attr_accessor :reel, :index
  attr_accessor :type
end

class RandomComponent < Gear::Core::Component
  attr_accessor :num_rng, :rngs
end

class RNGSysetm < Gear::Core::EntityProcessingSystem

  def initialize
    super(Gear::Core::Aspect.new_for_all RandomComponent)
  end

  def setup
    @position_mapper = Gear::Core::ComponentMapper.new(RandomComponent, @gamebox)
  end

  def process_entity(entity)
    puts "process #{entity}"
    rc = entity.get_component(RandomComponent)
    num_rng = rc.num_rng
    rc.rngs = []
    1.upto(num_rng) do |i|
      rc.rngs << rand(6)
    end
    puts "process #{entity.get_component(RandomComponent).rngs}"
  end
end

Slot.new.run