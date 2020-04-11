module DudePolicy
  module NilExtesion
    def dude
      DudePolicy::NilDudePolicy.instance
    end
  end
end
