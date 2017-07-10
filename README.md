## A simple Ruby Event Dispatcher

[![Build Status](https://travis-ci.org/dcsg/ruby-event-dispatcher.svg?branch=master)](https://travis-ci.org/dcsg/ruby-event-dispatcher)

A Ruby Event Dispatcher based on [Symfony Event Dispatcher](https://symfony.com/doc/current/components/event_dispatcher.html).

## How to Install

Add the following to your `Gemfile`:
```ruby
gem 'event-dispatcher', git: 'https://github.com/dcsg/ruby-event-dispatcher'
```

## How to use

#### Events
When an event is dispatched, it's identified by a unique name, which any number of listeners might be listening to. An Event instance is also created and passed to all of the listeners. As you'll see later, the Event object itself often contains data about the event being dispatched.

#### The Dispatcher
The dispatcher is the central object of the event dispatcher system.
In general, a single dispatcher is created, which maintains a registry of listeners.
When an event is dispatched via the dispatcher, it notifies all listeners registered with that event:

```ruby
require 'event-dispatcher'

dispatcher = EventDispatcher::Dispatcher.new
```

#### Adding Listeners

```ruby
class MyListener
  def on_foo_action(event)
    puts 'on foo action'
  end
end

listener = MyListener.new
dispatcher.add_listener('my.foo.action', [$listener, 'on_foo_action']);
```

#### Creating and Dispatching an Event

##### Creating the Event
```ruby
class OrderPlacedEvent < BaseEvent
    NAME = 'order.placed'.freeze

    attr_reader :order

    def initialize(order)
      @order = order
    end
end
```

##### Dispatching the Event
```ruby
order = Order.new
event = OrderPlacedEvent.new(order)
dispatcher.dispatch(OrderPlacedEvent::NAME, event)
```

## Contributing