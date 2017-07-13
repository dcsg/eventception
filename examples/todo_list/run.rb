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
require_relative 'todo_created_event'
require_relative 'todo_listener'
require_relative 'todo'

# configure the event dispatcher and register the listener
dispatcher = Eventception::Dispatcher.new
dispatcher.add_listener(
  event_name: TodoList::TodoCreatedEvent::NAME,
  listener: TodoList::TodoListener.new,
  listener_method: 'on_creation',
)

# create a new to-do and dispatch the event
todo = TodoList::Todo.new(title: 'Emit and Event', description: 'Event emitted')
event = TodoList::TodoCreatedEvent.new(todo)
dispatcher.dispatch(event_name: TodoList::TodoCreatedEvent::NAME, event: event)

# STDOUT: "created a new to-do with title: 'Emit and Event' and description: 'Event emitted'"
