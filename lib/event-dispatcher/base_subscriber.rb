module EventDispatcher
  class BaseSubscriber
    def subscribed_events
      raise NoMethodError, 'Method needs to be implement. Consider extend this class.'
    end
  end
end
