# frozen_string_literal: true

require 'eventception'

module TodoList
  class TodoCreatedEvent < Eventception::Event
    NAME = 'todo.created'.freeze

    attr_reader :todo

    def initialize(todo)
      @todo = todo
    end
  end
end
