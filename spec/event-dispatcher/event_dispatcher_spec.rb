require 'spec_helper'

describe EventDispatcher::Dispatcher do
  let(:listener) { proc { puts 'my listener' } }
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
          subject.add_listener(event_name: event_name, listener: listener)
        end

        it do
          expect(subject.listeners?).to be true
        end
      end
    end

    context 'when an event_name is provided' do
      context 'and does not have any listener associated' do
        it do
          expect(subject.listeners?(event_name: event_name)).to be false
        end
      end

      context 'and has one or more listeners associated' do
        before do
          subject.add_listener(event_name: event_name, listener: listener)
        end

        it do
          expect(subject.listeners?(event_name: event_name)).to be true
        end

        context 'when a different event_name is provided without any listener associated' do
          it do
            expect(subject.listeners?(event_name: :invalid)).to be false
          end
        end
      end
    end
  end

  describe '#add_listener' do
    context 'when no priority is provided' do
      before do
        subject.add_listener(event_name: event_name, listener: listener)
      end

      it 'adds a new listener to the event_name with 0 priority' do
        listeners = subject.listeners(event_name: event_name)

        expect(listeners[priority].count).to eq 1
        expect(listeners[priority].first).to eq listener
      end
    end

    context 'when priority of 10 is provided' do
      let(:priority) { 10 }

      before do
        subject.add_listener(event_name: event_name, listener: listener, priority: priority)
      end

      it 'adds a new listener to the event_name with a different priority' do
        listeners = subject.listeners(event_name: event_name)

        expect(listeners[priority].count).to eq 1
        expect(listeners[priority].first).to eq listener
      end
    end
  end

  describe '#listeners' do
    context 'when listeners exist' do
      before do
        subject.add_listener(event_name: event_name, listener: listener)
      end

      context 'when no event_name is provided' do
        it 'adds a new listener to the event_name with 0 priority' do
          listeners = subject.listeners

          expect(listeners.size).to eq 1
        end
      end

      context 'when an event_name is provided' do
        it 'adds a new listener to the event_name with 10 priority' do
          listeners = subject.listeners(event_name: event_name)

          expect(listeners[priority].count).to eq 1
          expect(listeners[priority].first).to eq listener
        end
      end
    end
  end

  describe '#remove_listener' do
    let(:listener2) { 'listener 2' }

    context 'when two listeners exist for the same event_name' do
      before do
        subject.add_listener(event_name: event_name, listener: listener)
        subject.add_listener(event_name: event_name, listener: listener2)
      end

      context 'and one of the listeners is removed' do
        it 'has only one listener' do
          expect(subject.listeners(event_name: event_name)[priority].size).to eq 2
          subject.remove_listener(event_name: event_name, listener: listener)
          expect(subject.listeners(event_name: event_name)[priority].size).to eq 1
        end
      end

      context 'and both listeners are removed' do
        it 'has zero listeners' do
          expect(subject.listeners(event_name: event_name)[priority].size).to eq 2
          subject.remove_listener(event_name: event_name, listener: listener)
          subject.remove_listener(event_name: event_name, listener: listener2)
          expect(subject.listeners(event_name: event_name)[priority].size).to eq 0
        end
      end
    end
  end

  describe '#add_subscriber' do
  end

  describe '#remove_subscriber' do
  end
end
