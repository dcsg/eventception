require 'eventception'
require_relative 'todo_created_event'
require_relative 'todo_listener'
require_relative 'todo'

# configure the event dispatcher and register the listener
dispatcher = Eventception::Dispatcher.new
listener = [Eventception::Examples::TodoList::TodoListener.new, 'on_creation']
dispatcher.add_listener(event_name: Eventception::Examples::TodoList::TodoCreatedEvent::NAME, listener: listener)

# create a new to-do and dispatch the event
todo = Eventception::Examples::TodoList::Todo.new(title: 'Emit and Event', description: 'Event emitted')
event = Eventception::Examples::TodoList::TodoCreatedEvent.new(todo)
dispatcher.dispatch(event_name: Eventception::Examples::TodoList::TodoCreatedEvent::NAME, event: event)

# STDOUT: "created a new to-do with title: 'Emit and Event' and description: 'Event emitted'"
