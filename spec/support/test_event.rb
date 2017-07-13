# frozen_string_literal: true

require 'event_dispatcher'

module EventDispatcher
  module Support
    class TestEvent < EventDispatcher::Event
      BEFORE = 'test.before'
      AFTER = 'test.after'
    end
  end
end
