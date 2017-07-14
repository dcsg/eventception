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

# @author Daniel Gomes <danielcesargomes@gmail.com>
module Eventception
  class ImmutableDispatcher
    private

    attr_reader :dispatcher

    public

    # Creates an unmodifiable proxy for an event dispatcher.
    #
    # == Parameters:
    # listeners::
    #   Array of event listeners
    # subscribers::
    #   Array of event subscribers
    #
    # == Returns:
    #   Nil
    #
    def initialize(listeners: [], subscribers: [])
      @dispatcher = Eventception::Dispatcher.new

      listeners.each do |listener|
        dispatcher.add_listener(
          event_name: listener.fetch(:event_name),
          listener: listener.fetch(:listener),
          listener_method: listener.fetch(:listener_method),
          priority: listener.fetch(:priority, 0),
        )
      end

      subscribers.each { |subscriber| dispatcher.add_subscriber(subscriber: subscriber) }

      nil
    end

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
      dispatcher.dispatch(event_name: event_name, event: event)

      event
    end

    # Gets all listeners sorted by descending priority.
    #
    # == Returns:
    #   All event listeners sorted by event_name and descending priority.
    #
    def listeners
      dispatcher.listeners
    end

    # Checks whether are any registered listeners.
    #
    # == Returns:
    #   Boolean
    #
    def listeners?
      dispatcher.listeners?
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
      dispatcher.listeners_for(event_name: event_name)
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
      dispatcher.listeners_for?(event_name: event_name)
    end
  end
end
