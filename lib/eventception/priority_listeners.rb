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

# @author Ivo Anjo <ivo.anjo@ist.utl.pt>
module Eventception
  class PriorityListeners
    include Enumerable

    private

    attr_reader :listeners

    public

    attr_reader :priority

    def initialize(priority:)
      @priority = priority
      @listeners = []
    end

    def <<(listener)
      listeners << listener
    end

    def <=>(other)
      other.priority <=> priority
    end

    def delete(listener)
      listeners.delete(listener)
    end

    def each(&block)
      listeners.each(&block)
    end

    def size
      listeners.size
    end

    def count
      size
    end

    def empty?
      listeners.empty?
    end
  end
end
