RSpec.describe DudePolicy do
  it "has a version number" do
    expect(DudePolicy::VERSION).not_to be nil
  end

  it "nil should be extended with NilDudePolicy" do
    expect(nil.dude).to be_kind_of DudePolicy::NilDudePolicy
    expect(nil.dude.inspect).to match /<#DudePolicy#\d* on nil>/

    expect(nil.policy).to be_kind_of DudePolicy::NilDudePolicy

    expect(nil.dude.whatever).to be false
    expect(nil.policy.whatever).to be false
  end
end
