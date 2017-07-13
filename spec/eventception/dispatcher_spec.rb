require 'spec_helper'
require 'support/listener'
require 'support/subscriber'
require 'support/test_event'

describe Eventception::Dispatcher do
  let(:listener) { Eventception::Support::Listener.new }
  let(:listener_callable) { [Eventception::Support::Listener.new, 'on_before'] }
  let(:subscriber) { Eventception::Support::Subscriber.new }
  let(:event_name) { :on_after }
  let(:priority) { 0 }

  describe '#listeners?' do
    context 'when no event_name is provided' do
      context 'and does not have any listeners associated' do
        it do
          expect(subject.listeners?).to be false
        end
      end

      context 'and has one or more listeners associated' do
        before do
          subject.add_listener(event_name: event_name, listener: listener_callable)
        end

        it do
          expect(subject.listeners?).to be true
        end
      end
    end

    context 'when an event_name is provided' do
      context 'and does not have any listener associated' do
        it do
          expect(subject.listeners_for?(event_name: event_name)).to be false
        end
      end

      context 'and has one or more listeners associated' do
        before do
          subject.add_listener(event_name: event_name, listener: listener_callable)
        end

        it do
          expect(subject.listeners_for?(event_name: event_name)).to be true
        end

        context 'when a different event_name is provided without any listener associated' do
          it do
            expect(subject.listeners_for?(event_name: :invalid)).to be false
          end
        end
      end
    end
  end

  describe '#add_listener' do
    context 'when no priority is provided' do
      before do
        subject.add_listener(event_name: event_name, listener: listener_callable)
      end

      it 'adds a new listener to the event_name with 0 priority' do
        listeners = subject.listeners_for(event_name: event_name)

        expect(listeners[priority].count).to eq 1
        expect(listeners[priority].first).to eq listener_callable
      end
    end

    context 'when priority of 10 is provided' do
      let(:priority) { 10 }

      before do
        subject.add_listener(event_name: event_name, listener: listener_callable, priority: priority)
      end

      it 'adds a new listener to the event_name with a different priority' do
        listeners = subject.listeners_for(event_name: event_name)

        expect(listeners[priority].count).to eq 1
        expect(listeners[priority].first).to eq listener_callable
      end
    end
  end

  describe '#listeners' do
    context 'when listeners exist' do
      before do
        subject.add_listener(event_name: event_name, listener: listener_callable)
      end

      context 'when no event_name is provided' do
        it 'adds a new listener to the event_name with 0 priority' do
          listeners = subject.listeners

          expect(listeners.size).to eq 1
        end
      end

      context 'when an event_name is provided' do
        it 'adds a new listener to the event_name with 10 priority' do
          listeners = subject.listeners_for(event_name: event_name)

          expect(listeners[priority].count).to eq 1
          expect(listeners[priority].first).to eq listener_callable
        end
      end
    end
  end

  describe '#remove_listener' do
    let(:listener_callable2) { [listener, 'on_after'] }

    context 'when two listeners exist for the same event_name' do
      before do
        subject.add_listener(event_name: event_name, listener: listener_callable)
        subject.add_listener(event_name: event_name, listener: listener_callable2)
      end

      it 'has two listeners' do
        expect(subject.listeners_for?(event_name: event_name)).to be true
        expect(subject.listeners_for(event_name: event_name)[priority].size).to eq 2
      end

      context 'and one of the listeners is removed' do
        it 'has only one listener' do
          subject.remove_listener(event_name: event_name, listener: listener_callable)
          expect(subject.listeners_for(event_name: event_name)[priority].size).to eq 1
        end
      end

      context 'and both listeners are removed' do
        it 'has zero listeners' do
          subject.remove_listener(event_name: event_name, listener: listener_callable)
          subject.remove_listener(event_name: event_name, listener: listener_callable2)
          expect(subject.listeners_for?(event_name: event_name)).to be false
          expect(subject.listeners_for(event_name: event_name).size).to eq 0
        end
      end
    end
  end

  describe '#add_subscriber' do
    before do
      subject.add_subscriber(subscriber: subscriber)
    end

    it 'subscribes two events' do
      listeners = subject.listeners
      expect(listeners.size).to eq 2
      listeners.each do |_event_name, listener|
        expect(listener[priority].size).to eq 1
      end
    end
  end

  describe '#remove_subscriber' do
    before do
      subject.add_subscriber(subscriber: subscriber)
    end

    it 'removes the subscriber listeners' do
      expect(subject.listeners.size).to eq 2
      subject.remove_subscriber(subscriber: subscriber)
      expect(subject.listeners?).to be false
    end
  end

  describe '#dispatch' do
    context 'when using subscribers' do
      before do
        subject.add_subscriber(subscriber: subscriber)
      end

      it 'calls the subscriber methods' do
        expect(subscriber).to receive('on_before').and_call_original
        expect(subscriber).to receive('on_after').and_call_original

        expect {
          subject.dispatch(event_name: Eventception::Support::TestEvent::BEFORE)
        }.to output(/on before, propagation stopped/).to_stdout
        expect {
          subject.dispatch(event_name: Eventception::Support::TestEvent::AFTER)
        }.to output(/on after, propagation stopped/).to_stdout
      end
    end

    context 'when using listeners' do
      before do
        subject.add_listener(event_name: event_name, listener: listener_callable)
      end

      it 'executes the listener method' do
        expect(listener).to receive(listener_callable[1]).and_call_original
        expect { subject.dispatch(event_name: event_name) }.to output(/before/).to_stdout
      end
    end
  end
end
