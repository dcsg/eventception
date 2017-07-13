require 'eventception/priority_listeners'

module Eventception
  class Dispatcher
    private

    def event_listeners
      @event_listeners ||= Hash.new { |hash, key|
        priority_listeners_hash = Hash.new { |priority_hash, priority_level|
          priority_hash[priority_level] = PriorityListeners.new(priority: priority_level)
        }

        hash[key] = priority_listeners_hash
      }
    end

    def sorted
      @sorted ||= Hash.new { |hash, key| hash[key] = {} }
    end

    public

    # Dispatches an event to all registered listeners.
    #
    # == Parameters:
    # event_name::
    #   The name of the event to dispatch. The name of
    #   the event is the name of the method that is
    #   invoked on listeners.
    # event::
    #   The event to pass to the event handlers/listeners
    #   If not supplied, an empty Event instance is created.
    #
    # == Returns:
    #   The Event.
    #
    def dispatch(event_name:, event: Eventception::Event.new)
      if listeners_for?(event_name: event_name)
        do_dispatch(listeners: listeners_for(event_name: event_name), event: event)
      end

      event
    end

    # Gets all listeners sorted by descending priority.
    #
    # == Returns:
    #   All event listeners sorted by event_name and descending priority.
    #
    def listeners
      return [] if event_listeners.empty?

      event_listeners.each_key do |event_name|
        sort_listeners(event_name) if sorted[event_name].empty?
      end

      sorted
    end

    # Checks whether are any registered listeners.
    #
    # == Returns:
    #   Boolean
    #
    def listeners?
      listeners.any?
    end

    # Gets all listeners for the specific event sorted by descending priority.
    #
    # == Returns:
    #   The event listeners for the specific event sorted by descending priority.
    #
    def listeners_for(event_name:)
      return [] if event_listeners[event_name].empty?

      sort_listeners(event_name) if sorted[event_name].empty?

      sorted[event_name]
    end

    # Checks whether are any registered listeners for the specific event.
    #
    # == Returns:
    #   Boolean
    #
    def listeners_for?(event_name:)
      event_listeners[event_name].any?
    end

    # Add an event listener that listens to the specified event.
    #
    # == Parameters:
    # event_name::
    #   The event to listen on
    # listener::
    #   The listener
    # priority::
    #   The higher this value, the earlier an event listener will be triggered in the chain (defaults to 0)
    #
    def add_listener(event_name:, listener_handler:, priority: 0)
      event_listeners[event_name][priority] << listener_handler
      sorted.delete(event_name)

      listener_handler
    end

    def remove_listener(event_name:, listener_handler:)
      return unless listeners_for?(event_name: event_name)

      listener_for_event = event_listeners.fetch(event_name)

      listener_for_event.each do |priority, priority_listeners|
        sorted.delete(event_name) if priority_listeners.delete(listener_handler)

        listener_for_event.delete(priority) if priority_listeners.empty?
      end

      event_listeners.delete(event_name) if listener_for_event.empty?
    end

    # Add an event subscriber.
    #
    # The subscriber is asked for all the events he is interested in and added as a listener for these events.
    #
    # == Parameters:
    # subscriber::
    #   The subscriber
    #
    def add_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        add_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener_handler: EventHandler.new(listener: subscriber, method: event_subscribed.fetch(:listener_method)),
          priority: event_subscribed[:priority] || 0,
        )
      end
    end

    def remove_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        remove_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener_handler: EventHandler.new(listener: subscriber, method: event_subscribed.fetch(:listener_method)),
        )
      end
    end

    protected

    # Triggers the listeners of an event.
    #
    # This method can be overridden to add functionality that is executed for each listener.
    #
    # == Parameters:
    # listeners::
    #   The event listeners
    # event::
    #   The event
    #
    def do_dispatch(listeners:, event:)
      listeners.each do |_priority, priority_listeners|
        priority_listeners.each do |listener_handler|
          return nil if event.propagation_stopped?

          listener_handler.call(event)
        end
      end

      nil
    end

    private

    # Sorts the internal list of listeners for the given event by priority.
    #
    # == Parameters:
    # event_name::
    #   The event name
    #
    def sort_listeners(event_name)
      sorted[event_name] = event_listeners[event_name].sort_by { |key, _| -key }.to_h
    end
  end
end
