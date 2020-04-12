# Dude Policy

This gem provides a way  how to do Ruby on Rails [Policy Objects](https://blog.eq8.eu/article/policy-object.html)
from point of view of current_user/current_account (the **dude**)

![](https://triblive.com/wp-content/uploads/2019/01/673808_web1_gtr-liv-goldenglobes-121718.jpg)

Here are some examples what we mean:


```ruby
# irb
article = Article.find(123)
review  = Review.find(123)
current_user = User.find(432) # e.g. Devise on any authentication solution

current_user.dude.able_to_edit_article?(article)
# => true

current_user.dude.able_to_add_article_review?(article)
# => true

current_user.dude.able_to_delete_review?(review)
# => false
```

[RSpec](https://rspec.info/) examples:

```ruby
# spec/any_file_spec.rb
RSpec.describe 'short demo' do
  let(:author_user)  { User.create }
  let(:article) { Article.create(author: author_user) }
  let(:different_user)  { User.create }

  # you write tests like this:
  it { expect(author_user.able_to_edit_article?(article)).to be_truthy }

  # or you can take advantage of native `be_` RSpec matcher that converts any questionmark ending method to matcher
  it { expect(author_user).to be_able_to_edit_article(article) }
  it { expect(different_user).not_to be_able_to_edit_article(article) }
  it { expect(author_user).not_to be_able_to_add_article_review(article) }
  it { expect(different_user).to be_able_to_add_article_review(article) }
  it { expect(author_user).not_to be_able_to_delete_review(article) }
  it { expect(different_user).to be_able_to_add_article_review(article) }
end
```

Policy objects:

```ruby
# app/policy/article_policy.rb
class ArticlePolicy < DudePolicy::BasePolicy
  def able_to_update_article?(dude:)
    return true if article.author == dude
    false
  end

  def able_to_add_article_review?(dude:)
    return true if article.author != dude
    false
  end

  private

  def article
    resource # delegation defined in DudePolicy::BasePolicy
  end
end
```

Full example in example app

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dude_policy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dude_policy

## Usage

### Gem is responsible for Authorization

Gem will provide a way how to do `Authorization` (whan logged in user can/cannot do)

For `Authentication` (is User logged in ?) you will need a different solution / gem (e.g. [Devise](https://github.com/heartcombo/devise), custom login solution, ...)



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/equivalent/dude_policy This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dude_policy/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DudePolicy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/equivalent/dude_policy/blob/master/CODE_OF_CONDUCT.md).
