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

require 'eventception'
require_relative 'test_event'

# @author Daniel Gomes <danielcesargomes@gmail.com>
module Eventception
  module Support
    class Subscriber < Eventception::BaseSubscriber
      def subscribed_events
        [
          { event_name: TestEvent::BEFORE, listener_method: 'on_before', priority: 0 },
          { event_name: TestEvent::AFTER, listener_method: 'on_after' },
        ]
      end

      def on_before(event)
        puts "on before, propagation stopped? #{event.propagation_stopped?}"
      end

      def on_after(event)
        puts "on after, propagation stopped? #{event.propagation_stopped?}"
      end
    end
  end
end
