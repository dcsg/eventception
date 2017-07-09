module EventDispatcher
  class Listener
    def on_before(_event)
      puts 'before'
    end

    def on_after(_event)
      puts 'after'
    end
  end
end
