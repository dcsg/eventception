require 'event-dispatcher/dispatcher'
require_relative 'todo_created_event'
require_relative 'todo_listener'
require_relative 'todo'

# configure the event dispatcher and register the listener
dispatcher = EventDispatcher::Dispatcher.new
listener = [EventDispatcher::Examples::TodoList::TodoListener.new, 'on_creation']
dispatcher.add_listener(event_name: EventDispatcher::Examples::TodoList::TodoCreatedEvent::NAME, listener: listener)

# create a new to-do and dispatch the event
todo = EventDispatcher::Examples::TodoList::Todo.new(title: 'Emit and Event', description: 'Event emitted')
event = EventDispatcher::Examples::TodoList::TodoCreatedEvent.new(todo)
dispatcher.dispatch(event_name: EventDispatcher::Examples::TodoList::TodoCreatedEvent::NAME, event: event)

# STDOUT: "created a new to-do with title: 'Emit and Event' and description: 'Event emitted'"
