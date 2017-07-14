# frozen_string_literal: true

# Eventception: A lightweight and simple Ruby Event System
# Copyright (C) 2017 Daniel Gomes <danielcesargomes@gmail.com>
#
# This file is part of Eventception.
#
# Eventception is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Eventception is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Eventception. If not, see <http://www.gnu.org/licenses/>.

require 'eventception/priority_listeners'
require 'eventception/listener_handler'

# @author Daniel Gomes <danielcesargomes@gmail.com>
# @author Ivo Anjo <ivo.anjo@ist.utl.pt>
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
    # == Parameters:
    # event_name::
    #   The name of the event
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
    # == Parameters:
    # event_name::
    #   The name of the event
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
    # listener_method::
    #   The name of the method to be executed in the listener
    # priority::
    #   The higher this value, the earlier an event listener will be triggered in the chain (defaults to 0)
    #
    # == Returns:
    #   Nil
    #
    def add_listener(event_name:, listener:, listener_method:, priority: 0)
      event_listeners[event_name][priority] << ListenerHandler.new(listener, listener_method)
      sorted.delete(event_name)

      nil
    end

    # Removes an event listener from the specified events.
    #
    # == Parameters:
    # event_name::
    #   The event to listen on
    # listener::
    #   The listener
    # listener_method::
    #   The name of the method to be executed in the listener
    #
    # == Returns:
    #   Nil
    #
    def remove_listener(event_name:, listener:, listener_method:)
      return unless listeners_for?(event_name: event_name)

      listener_for_event = event_listeners.fetch(event_name)

      listener_for_event.each do |priority, priority_listeners|
        sorted.delete(event_name) if priority_listeners.delete(ListenerHandler.new(listener, listener_method))

        listener_for_event.delete(priority) if priority_listeners.empty?
      end

      event_listeners.delete(event_name) if listener_for_event.empty?

      nil
    end

    # Add an event subscriber.
    #
    # The subscriber is asked for all the events he is interested in and added as a listener for these events.
    #
    # == Parameters:
    # subscriber::
    #   The subscriber
    #
    # == Returns:
    #   Nil
    #
    def add_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        add_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener: subscriber,
          listener_method: event_subscribed.fetch(:listener_method),
          priority: event_subscribed[:priority] || 0,
        )
      end

      nil
    end

    # Removes an event subscriber.
    #
    # The subscriber is asked for all the events he is interested in and added as a listener for these events.
    #
    # == Parameters:
    # subscriber::
    #   The subscriber
    #
    # == Returns:
    #   Nil
    #
    def remove_subscriber(subscriber:)
      subscriber.subscribed_events.each do |event_subscribed|
        remove_listener(
          event_name: event_subscribed.fetch(:event_name),
          listener: subscriber,
          listener_method: event_subscribed.fetch(:listener_method),
        )
      end

      nil
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
    # == Returns:
    #   Nil
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
    # == Returns:
    #   Nil
    #
    def sort_listeners(event_name)
      sorted[event_name] = event_listeners[event_name].sort_by { |key, _| -key }.to_h

      nil
    end
  end
end
