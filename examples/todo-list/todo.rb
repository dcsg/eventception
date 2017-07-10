module EventDispatcher
  module Examples
    module TodoList
      class Todo
        attr_reader :title
        attr_reader :description

        def initialize(title:, description:)
          @title = title
          @description = description
        end
      end
    end
  end
end
