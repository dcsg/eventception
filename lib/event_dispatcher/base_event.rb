module EventDispatcher
  class BaseEvent
    private

    attr_reader :propagation_stopped

    public

    def initialize
      @propagation_stopped = false
    end

    def propagation_stopped?
      propagation_stopped
    end

    def stop_propagation
      @propagation_stopped = true
    end
  end
end
