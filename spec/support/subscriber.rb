require 'eventception'
require_relative 'test_event'

module Eventception
  module Support
    class Subscriber < Eventception::BaseSubscriber
      def subscribed_events
        [
          { event_name: TestEvent::BEFORE, listener_method: 'on_before', priority: 0 },
          { event_name: TestEvent::AFTER, listener_method: 'on_after' },
        ]
      end

      def on_before(event)
        puts "on before, propagation stopped? #{event.propagation_stopped?}"
      end

      def on_after(event)
        puts "on after, propagation stopped? #{event.propagation_stopped?}"
      end
    end
  end
end
