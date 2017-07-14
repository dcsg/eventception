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

require 'spec_helper'
require 'support/listener'
require 'support/subscriber'
require 'support/test_event'

# @author Daniel Gomes <danielcesargomes@gmail.com>
describe Eventception::ImmutableDispatcher do
  subject(:dispatcher) { described_class.new(listeners: listeners, subscribers: subscribers) }

  let(:listener) { Eventception::Support::Listener.new }
  let(:listener_method) { 'on_before' }
  let(:listeners) { [] }
  let(:subscriber) { Eventception::Support::Subscriber.new }
  let(:subscribers) { [] }
  let(:event_name) { :on_after }
  let(:priority) { 0 }

  describe '#initialize' do
    context 'when one listener is provided' do
      let(:listeners) {
        [
          {event_name: event_name, listener: listener, listener_method: listener_method, priority: priority},
        ]
      }

      it 'then a listener is registered' do
        expect(dispatcher.listeners?).to be true
      end

      it 'then it have one listener registered' do
        expect(dispatcher.listeners.size).to eq 1
      end

      it 'then a listener for the event \'on_before\' is registered' do
        expect(dispatcher.listeners_for?(event_name: event_name)).to be true
      end

      it 'then no listeners are registered for an invalid event name' do
        expect(dispatcher.listeners_for?(event_name: :invalid)).to be false
      end
    end
  end
end
