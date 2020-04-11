require 'spec_helper'
RSpec.describe DudePolicy::Dude do
  let(:current_user) { User.new } # User is a model that is a dude
  let(:article) { Article.new } # Article is a model that has policy
  let(:current_account) { Account.new } # Account is a model that is a dude and has_policy as well

  it { expect(current_user.dude).to be_kind_of(DudePolicy::Dude) }
  it { expect(current_user.dude.inspect).to match /<#CurrentUserPolicy#\d* User#123>/ }


  it { expect(current_account.dude).to be_kind_of(DudePolicy::Dude) }
  it { expect(current_account.dude.inspect).to match /<#CurrentUserPolicy#\d* Account>/ }

  it do
    expect(current_user.dude.able_to_update_article(article))
  end
end
