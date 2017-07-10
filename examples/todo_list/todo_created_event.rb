require 'event-dispatcher/base_event'

module EventDispatcher
  module Examples
    module TodoList
      class TodoCreatedEvent < BaseEvent
        NAME = 'todo.created'.freeze

        attr_reader :todo

        def initialize(todo)
          @todo = todo
        end
      end
    end
  end
end
