require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without an email" do
    expect(build(:user, email: nil)).to_not be_valid
  end

  it "is invalid without a username" do
    expect(build(:user, username: nil)).to_not be_valid
  end

  it "is invalid without a provider" do
    expect(build(:user, provider: nil)).to_not be_valid
  end

  it "is invalid without a uid" do
    expect(build(:user, uid: nil)).to_not be_valid
  end

  it "has a default role of student" do
    user = build(:user, role: nil)
    expect(user.role) == :student
  end
end
