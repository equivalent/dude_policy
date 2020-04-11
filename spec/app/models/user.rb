class User
  include DudePolicy::IsADude

  def id
    123
  end
end
