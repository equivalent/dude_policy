module DudePolicy
  module IsADude
    def dude
      @dude ||= DudePolicy::Dude.new(self)
    end
  end
end
