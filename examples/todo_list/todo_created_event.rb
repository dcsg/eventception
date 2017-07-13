require 'event_dispatcher'

module EventDispatcher
  module Examples
    module TodoList
      class TodoCreatedEvent < Event
        NAME = 'todo.created'.freeze

        attr_reader :todo

        def initialize(todo)
          @todo = todo
        end
      end
    end
  end
end
