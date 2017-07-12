module Eventception
  class Event
    private

    def propagation_stopped
      @propagation_stopped ||= false
    end

    public

    def propagation_stopped?
      propagation_stopped
    end

    def stop_propagation
      @propagation_stopped = true
    end
  end
end
