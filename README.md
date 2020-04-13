# Dude Policy

This gem provides a way  how to do Ruby on Rails [Policy Objects](https://blog.eq8.eu/article/policy-object.html)
from point of view of current_user/current_account (the **dude**)

![](https://triblive.com/wp-content/uploads/2019/01/673808_web1_gtr-liv-goldenglobes-121718.jpg)

Here are some examples what I mean:


```ruby
# rails console
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

> For more examples pls check the [example app](https://github.com/equivalent/dude_policy_example1)

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

Gem is responsible for **Authorization** (what a logged in user can/cannot do)
For **Authentication** (is User logged in ?) you will need a different solution / gem (e.g. [Devise](https://github.com/heartcombo/devise), custom login solution, ...)

Once you have your Authentication solution implemeted and `dude_policy`
gem installed create a directory `app/policy`  in your Ruby on Rails
app.

> Note: Since Rails version 4 files in `app/anything` directories are autoloaded. So no additional magic is needed

There create your policy file:


```ruby
# app/policy/article_policy
class ArticlePolicy < DudePolicy::BasePolicy
  def able_to_update_article?(dude:)
    return true if dude.admin?
    return true if dude == resource.author
    false
  end
end
```


> Note: Policy should be name as the model suffixed with word "Policy". So if
> you have `ConstructiveComment` model your policy should be named `ConstructiveCommentPolicy` located in `app/policy/constructive_comment_policy.rb`


You also need to tell your models what role they play

```ruby
class Article < ApplicationRecord
  include DudePolicy::HasPolicy  # will add a method `article.policy`

  # ...
end
```


```ruby
class User < ApplicationRecord
  include DudePolicy::IsADude   # will add a method `user.dude`
  include DudePolicy::HasPolicy # will add a method `user.policy`

  # ...
end
```

This way you will be able to call:

```ruby
user = User.find(123)
user.dude.able_to_update_article?(@article)
```

> Note: same model can include both `DudePolicy::IsADude` and `DudePolicy::IsADude` but don't have to.

> Note: please be sure to check the [Philosophy](https://github.com/equivalent/dude_policy#philospophy) section of this README to fully understand the flow

This way you will be implement it in your application:

#### protect views

```erb
<%= link_to 'Edit', edit_article_path(@article) if current_user.dude.able_to_update_article?(@article) %>
```

#### protect controllers

```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # ...

  def update
    @article = Article.find_by(params[:id])
    raise(DudePolicy::NotAuthorized) unless current_user.dude.able_to_update_article?(@article)

    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end
end
```

> gem provides error class `DudePolicy::NotAuthorized` so you
> can implement [rescue_from](https://apidock.com/rails/ActiveSupport/Rescuable/ClassMethods/rescue_from) logic around not authenticated
> scenarios. If you have no idea what I'm talking about pls check [example application code](https://github.com/equivalent/dude_policy_example1/blob/master/app/controllers/application_controller.rb)

#### protect business logic

There are cases when you want to protect your business logic that is
beyond MVC level. For example:

```ruby
# app/polcy/user_policy.rb
class UserPolicy < DudePolicy::BasePolicy
  def able_to_see_user_full_name?(dude:)
    return true if dude.admin?
    return true if dude == resource
    false
  end
end


# app/helpers/application_helper.rb
def author_name(user)
  return unless user
  if current_user.dude.able_to_see_user_full_name?(user)
    user.name
  else
    first_letter = user.name[0]
    "#{first_letter}."
  end
end
```

#### RSpec  testing


##### policy test

You should be writing tests from perspective of current_user / current_account (the dude) and what roles they play.

If you have 2 roles (admin/regular user) test all policy methods for both
roles. If you have 8 roles (admin/moderator/client-manager/external-employee/noob/...) test all policy methods from all eight perspectives.

```ruby
# spec/policy/article_policy_spec.rb
require 'rails_helper'
RSpec.describe ArticlePolicy do
  let(:article) { create :article, author: author }
  let(:author)  { create :user }

  context 'when nil user' do
    let(:current_user) { nil }

    it { expect(current_user.dude).not_to be_able_to_update_article(article) }
    it { expect(current_user.dude).not_to be_able_to_delete_article(article) }
  end

  context 'when regular_user' do
    let(:current_user) { create :user }

    it { expect(current_user.dude).not_to be_able_to_update_article(article) }
    it { expect(current_user.dude).not_to be_able_to_delete_article(article) }

    context ' is author of article' do
      let(:author) { current_user }
      it { expect(current_user.dude).to be_able_to_update_article(article) }
      it { expect(current_user.dude).to be_able_to_delete_article(article) }
    end
  end

  context 'when admin' do
    let(:current_user) { create :user, admin: true }
    it { expect(current_user.dude).to be_able_to_update_article(article) }
    it { expect(current_user.dude).not_to be_able_to_delete_article(article) }

    context ' is author of article' do
      let(:author) { current_user }
      it { expect(current_user.dude).to be_able_to_update_article(article) }
      it { expect(current_user.dude).to be_able_to_update_article(article) }
    end
  end
end
```


Do yourself a favor and **don't write low level Unit Tests** like `expect(ArticlePolicy.new(article)).to be_able_to_update_article(dude: current_user)` !
When it comes to policy tests this can lead to huge security disasters ([full explanation](https://blog.eq8.eu/assets/2019/unit-test.jpg))

##### request test

Now that we tested policy for every possible role of a user we can stub
the policy. We want to do it on the same interface level as we tested our policies
that means `allow(current_user.dude).to receive(:able_to_update_article?).and_return(true)`

> note: simmilar approach we would apply if you write controller RSpec test


```ruby
require 'rails_helper'
RSpec.describe "Articles", type: :request do
  let(:article) { create :article }

  describe "put /articles/xxxx" do
    def trigger_update
      if current_user
        # devise login
        sign_in current_user

        # policies are tested with `spec/policy/article_spec.rb so we can stub
        allow(current_user.dude)
          .to receive(:able_to_update_article?)
          .with(article)
          .and_return(authorized)
      end

      put article_path(article), params: {format: :html, article: { title: 'cat' }}
      article.reload
    end

    context 'when not authenticated' do
      let(:current_user) { nil }

      it { expect { trigger_update }.not_to change { article.title } }
      it do
        trigger_update
        expect(response.status).to eq 302 # redirect by update
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when authenticated' do
      let(:current_user) { create :user }

      context 'when not authorized' do
        let(:authorized) { false }

        it { expect { trigger_update }.not_to change { article.title } }
        it do
          trigger_update
          expect(response.status).to eq 302 # redirect to root_path by `authenticate!` method is ApplicationController
          follow_redirect!
          expect(response.body).to include('Sorry current user is not authorized to perform this action')
        end
      end

      context 'when authorized' do
        let(:authorized) { true }

        it { expect { trigger_update }.to change { article.title }.from('interesting article').to('cat') }
        it do
          trigger_update
          expect(response.status).to eq 302
          follow_redirect!
          expect(response.body).to include('Article was successfully updated.')
        end
      end
    end
  end
end
```


#### More examples

> For more examples pls check the [example app](https://github.com/equivalent/dude_policy_example1)


## Philosophy

I've spent many years and tone of time playing around with different Authorization
solutions and philosophies. All boils down to fact that [Policy Objects](https://blog.eq8.eu/article/policy-object.html) are the best you can implement.

Problem is that though there are  decent policy object solutions usually
they are not specific enough on implementation strategy  and teams/teammates still create a
mess.

But by taking a stand that all policy implementation will be from point of
view "what current_user can/cannot do" you solve multiple problems.

@todo - I'll add more details soon

#### Naming policy methods

Your policy objects are just simple Ruby objects so there is no
restriction to name your methods in in anything you want.

From experience I highly advise you to name the policy methods as
`able_to_` + `action` + `resource_name`

example

```ruby
class ProductPolicy < DudePolicy::BasePolicy
  def able_to_delete_product(dude:)
    #...
  end

  def able_to_add_product_review_comment(dude:)
    #...
  end
end

class ReviewCommentPolicy < DudePolicy::BasePolicy
  
  def able_to_delete_review_comment(dude:)
    #...
  end
end
```
#### Actions from point of parent model

@ todo ... I'll add more here soon

#### Nil overide

once you install gem you may notice that you are able to do
`nil.dude.can_do_anything? => false` this is a feature not a bug.

Sometimes your application need to deal with `nil` as current_user and
you don't want to have conditions `if current_user` all over the place.
That's why gem implements [Null Object Pattern](https://avdi.codes/null-objects-and-falsiness/) on `nil.dude` method that returns `false` all the time


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/equivalent/dude_policy This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/equivalent/dude_policy/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DudePolicy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/equivalent/dude_policy/blob/master/CODE_OF_CONDUCT.md).
