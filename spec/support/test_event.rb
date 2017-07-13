# frozen_string_literal: true

require 'eventception'

module Eventception
  module Support
    class TestEvent < Eventception::Event
      BEFORE = 'test.before'
      AFTER = 'test.after'
    end
  end
end
