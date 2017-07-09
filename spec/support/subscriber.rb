module EventDispatcher
  class Subscriber < BaseSubscriber
    def subscribed_events
      [
        { event_name: :on_before, method: [self, 'on_before'] },
        { event_name: :on_after, method: [self, 'on_after'] },
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
