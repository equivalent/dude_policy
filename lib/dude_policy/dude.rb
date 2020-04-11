module DudePolicy
  class Dude
    attr_reader :dude

    def initialize(current_dude)
      @dude = current_dude
    end

    def inspect
      id = "##{dude.id}" if dude.respond_to?(:id)
      "<#CurrentUserPolicy##{object_id} #{dude.class.name}#{id}>"
    end
  end
end
