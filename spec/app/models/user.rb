class User
  include DudePolicy::IsADude

  attr_reader :id

  def initialize(id: 123)
    @id = id
  end
end
