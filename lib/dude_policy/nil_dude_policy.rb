module DudePolicy
  class NilDudePolicy
    include Singleton

    def method_missing(*)
      false
    end

    # test frameworks like RSpec test first if method responds to before calling it
    # as this is a NullObject delegator it responds to any method call
    def respond_to?(*)
      true
    end

    def inspect
      "<#DudePolicy##{object_id} on nil>"
    end
  end
end
