module DudePolicy
  module NilExtesion
    def dude
      DudePolicy::NilDudePolicy.instance
    end

    def policy
      DudePolicy::NilDudePolicy.instance
    end
  end
end
