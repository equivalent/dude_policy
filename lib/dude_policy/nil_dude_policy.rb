module DudePolicy
  class NilDudePolicy
    include Singleton

    def method_missing(*)
      false
    end

    def inspect
      "<#DudePolicy##{object_id} on nil>"
    end
  end
end
