require 'eventception'
require 'spec_helper'
require 'support/listener'
require 'support/subscriber'
require 'support/test_event'
require 'support/listener'

describe Eventception::ListenerHandler do
  subject(:event_handler) { described_class.new(listener, listener_method) }

  let(:listener_method) { 'on_before' }
  let(:listener_method2) { 'on_after' }
  let(:listener) { Eventception::Support::Listener.new }
  let(:listener2) { Eventception::Support::Listener.new }

  describe '#call' do
    it 'executes the listener method' do
      expect(listener).to receive(listener_method)

      event_handler.call(Eventception::Event.new)
    end
  end

  describe '#==' do
    context 'when the two event handlers have the same listener and method' do
      let(:event_handler2) { described_class.new(listener, listener_method) }

      it do
        expect(event_handler == event_handler2).to be true
      end
    end

    context 'when the two event handlers have different listener and same method' do
      let(:event_handler2) { described_class.new(listener2, listener_method) }

      it do
        expect(event_handler == event_handler2).to be false
      end
    end

    context 'when the two event handlers have same listener but different method' do
      let(:event_handler2) { described_class.new(listener, listener_method2) }

      it do
        expect(event_handler == event_handler2).to be false
      end
    end
  end

  describe '#eql?' do
    context 'when the two event handlers have the same listener and method' do
      let(:event_handler2) { described_class.new(listener, listener_method) }

      it do
        expect(event_handler.eql?(event_handler2)).to be true
      end
    end

    context 'when the two event handlers have different listener and same method' do
      let(:event_handler2) { described_class.new(listener2, listener_method) }

      it do
        expect(event_handler.eql?(event_handler2)).to be false
      end
    end

    context 'when the two event handlers have same listener but different method' do
      let(:event_handler2) { described_class.new(listener, listener_method2) }

      it do
        expect(event_handler.eql?(event_handler2)).to be false
      end
    end
  end
end
