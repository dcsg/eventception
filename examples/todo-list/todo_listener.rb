module EventDispatcher
  module Examples
    module TodoList
      class TodoListener
        def on_creation(event)
          puts "created a new to-do with title: '#{event.todo.title}' and description: '#{event.todo.description}'"
        end
      end
    end
  end
end
