class ArticlePolicy < DudePolicy::BasePolicy
  def able_to_update_article(dude:)
    return true if dude.id == 123
    false
  end

end
