module EventDispatcher
  class Dispatcher
    private

    def event_listeners
      @event_listeners ||= Hash.new { |hash, key| hash[key] = {} }
    end

    def sorted
      @sorted ||= Hash.new { |hash, key| hash[key] = {} }
    end

    public

    def dispatch(event_name:, event: EventDispatcher::Event.new)
      return event unless listeners_for?(event_name: event_name)

      do_dispatch(listeners: listeners_for(event_name: event_name), event: event)

      event
    end

    def listeners
      return [] if event_listeners.empty?

      event_listeners.each_key do |event_name|
        sort_listeners(event_name) if sorted[event_name].nil? || sorted[event_name].empty?
      end

      sorted
    end

    def listeners_for(event_name:)
      return [] if !event_listeners.key?(event_name) || event_listeners[event_name].empty?

      sort_listeners(event_name) if sorted[event_name].nil? || sorted[event_name].empty?

      sorted[event_name]
    end

    def listeners?
      !listeners.empty?
    end

    def listeners_for?(event_name:)
      event_listeners.key?(event_name) && !event_listeners[event_name].empty?
    end

    def add_listener(event_name:, listener:, priority: 0)
      event_listeners[event_name][priority] ||= []
      event_listeners[event_name][priority] << listener
      sorted.delete(event_name)
    end

    def remove_listener(event_name:, listener:)
      return if !event_listeners.key?(event_name) || event_listeners[event_name].empty?

      listener_for_event = event_listeners.fetch(event_name)
      listener_for_event.each do |priority, event_listeners|
        event_listeners.each do |event_listener|
          if event_listener == listener
            event_listeners.delete(listener)
            sorted.delete(event_name)
          end
        end

        listener_for_event.delete(priority) if event_listeners.empty?
      end

      event_listeners.delete(event_name) if listener_for_event.empty?
    end

    def add_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        add_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener: [subscriber, event_subscribed.fetch(:listener_method)],
          priority: event_subscribed[:priority] || 0,
        )
      end
    end

    def remove_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        remove_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener: [subscriber, event_subscribed.fetch(:listener_method)],
        )
      end
    end

    protected

    def do_dispatch(listeners:, event:)
      listeners.each do |_priority, event_listeners|
        event_listeners.each do |listener|
          break if event.propagation_stopped?

          listener[0].public_send(listener[1], event)
        end
      end
    end

    private

    def sort_listeners(event_name)
      sorted[event_name] = event_listeners[event_name].sort.to_h
    end
  end
end
