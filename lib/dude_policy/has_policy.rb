module DudePolicy
  module HasPolicy
    def policy
      @policy ||= policy_name.constantize.new(self)
    end

    def policy_name
      "#{self.class.name}Policy"
    end
  end
end
