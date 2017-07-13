## Eventception

[![Build Status](https://travis-ci.org/dcsg/eventception.svg?branch=master)](https://travis-ci.org/dcsg/eventception)

Eventception is a lightweight and simple Ruby Event System inspired on [Symfony Event Dispatcher](https://symfony.com/doc/current/components/event_dispatcher.html).

## How to Install

Add the following to your `Gemfile`:
```ruby
gem 'eventception', '~> 0.0.1'
```

## How to use

#### Events
When an event is dispatched, it's identified by a unique name, which any number of listeners might be listening to. An Event instance is also created and passed to all of the listeners. As you'll see later, the Event object itself often contains data about the event being dispatched.

#### The Dispatcher
The dispatcher is the central object of the event dispatcher system.
In general, a single dispatcher is created, which maintains a registry of listeners.
When an event is dispatched via the dispatcher, it notifies all listeners registered with that event:

```ruby
require 'eventception'

dispatcher = Eventception::Dispatcher.new
```

#### Adding Listeners

```ruby
require 'eventception'
class TodoListener
  def on_creation(event)
    puts "created a new to-do with title: '#{event.todo.title}'"
  end
end

listener = TodoListener.new
dispatcher.add_listener(
  event_name: 'todo.created',
  listener: listener,
  listener_method: 'on_creation'
)
```

#### Creating and Dispatching an Event

##### Creating the Event
```ruby
require 'eventception'
class TodoCreatedEvent < Eventception::Event
    NAME = 'todo.created'.freeze

    attr_reader :todo

    def initialize(todo)
      @todo = todo
    end
end
```

##### Dispatching the Event
```ruby
class Todo
    attr_reader :title

    def initialize(title:)
      @title = title
    end
end

todo = Todo.new('My To-do')
event = TodoCreatedEvent.new(todo)
dispatcher.dispatch(TodoCreatedEvent::NAME, event)

# STDOUT: created a new to-do with title: 'My To-do'
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## Contributors

 * [Daniel Gomes](https://github.com/dcsg)
 * [Ivo Anjo](https://github.com/ivoanjo)
