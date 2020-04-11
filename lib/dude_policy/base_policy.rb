module DudePolicy
  class BasePolicy
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def inspect
      "<#{self.class.name}##{object_id} resource:#{resource.class.name}>"
    end
  end
end
