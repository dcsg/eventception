module Eventception
  class EventHandler
    attr_reader :listener
    attr_reader :method

    def initialize(listener:, method:)
      @listener = listener
      @method = method
    end

    def call(event)
      listener.public_send(method, event)
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      listener == other.listener && method == other.method
    end
  end
end
