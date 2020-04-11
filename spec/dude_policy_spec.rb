RSpec.describe DudePolicy do
  it "has a version number" do
    expect(DudePolicy::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(nil.dude).to be_kind_of DudePolicy::NilDudePolicy
  end
end
