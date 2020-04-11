module DudePolicy
  class Dude
    attr_reader :dude

    def initialize(current_dude)
      @dude = current_dude
    end

    def inspect
      id = "##{dude.id}" if dude.respond_to?(:id)
      "<#DudePolicy::Dude##{object_id} #{dude.class.name}#{id}>"
    end

    def method_missing(name, resource)
      resource.policy.send(name, dude: dude)
    end

    # RSpec mocks are checking if object responds to calls
    # Due to fact that we use method_missing is delegating responsibility
    # Dude class responds to all calls
    def respond_to?(*)
      true
    end
  end
end
