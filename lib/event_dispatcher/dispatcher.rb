module EventDispatcher
  class Dispatcher
    private

    def event_listeners
      @event_listeners ||= Hash.new { |hash, key| hash[key] = {}  }
    end

    def sorted
      @sorted ||= Hash.new { |hash, key| hash[key] = {} }
    end

    def dispatch(event_name:, event: EventDispatcher::BaseEvent.new)
      listeners = listeners(event_name: event_name)

      do_dispatch(listeners: listeners, event: event) if listeners

      event
    end

    def listeners(event_name: nil)
      unless event_name.nil?
        return [] if !event_listeners.key?(event_name) || event_listeners[event_name].empty?

        sort_listeners(event_name: event_name) if sorted[event_name].nil? || sorted[event_name].empty?

        return sorted[event_name]
      end

      event_listeners.each_key do |key|
        sort_listeners(event_name: key) if sorted[key].nil? || sorted[key].empty?
      end

      sorted
    end

    def listeners?(event_name: nil)
      unless event_name.nil?
        return event_listeners.key?(event_name) && !event_listeners[event_name].empty?
      end

      event_listeners.each { |listener| return true if listener }

      false
    end

    def add_listener(event_name:, listener:, priority: 0)
      event_listeners[event_name] ||= {}
      event_listeners[event_name][priority] ||= []
      event_listeners[event_name][priority] << listener
      sorted.delete(event_name)
    end

    def remove_listener(event_name:, listener:)
      return if !event_listeners.key?(event_name) || event_listeners[event_name].empty?

      event_listeners.each do |_k, priorities|
        priorities.each do |_priority, listeners|
          listeners.each do |i|
            if i == listener
              listeners.delete(listener)
              sorted.delete(event_name)
            end
          end
        end
      end
    end

    def add_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        priority = event_subscribed[:priority] || 0
        add_listener(event_name: event_subscribed[:event_name], listener: event_subscribed[:method], priority: priority)
      end
    end

    def remove_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        remove_listener(event_name: event_subscribed[:event_name], listener: event_subscribed[:method])
      end
    end

    protected

    def do_dispatch(listeners:, event:)
      listeners.each do |_priority, event_listeners|
        break if event.propagation_stopped?
        event_listeners.each do |listener|
          break if event.propagation_stopped?

          listener[0].public_send(listener[1], event)
        end
      end
    end

    private

    def sort_listeners(event_name:)
      sorted[event_name] = {}
      sorted[event_name] = event_listeners[event_name].sort.to_h
    end
  end
end
