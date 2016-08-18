module Gear::Core  
  class Bag < Hash

    def add(e, id = nil)
      self[id || e.id] = e
    end

    def remove(e)
      if e.is_a?(Entity)
        self.delete(e.id)
      else
        self.delete_if { |k, v| v == e }
      end
    end

    # Use each_pair instead of each
    alias_method :each, :each_value
  end
end