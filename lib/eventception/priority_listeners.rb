module Eventception
  class PriorityListeners
    include Enumerable

    private

    attr_reader :listeners

    public

    attr_reader :priority

    def initialize(priority:)
      @priority = priority
      @listeners = []
    end

    def <<(listener)
      listeners << listener
    end

    def <=>(other)
      other.priority <=> priority
    end

    def delete(listener)
      listeners.delete(listener)
    end

    def each(&block)
      listeners.each(&block)
    end

    def size
      listeners.size
    end

    def count
      size
    end

    def empty?
      listeners.empty?
    end
  end
end
