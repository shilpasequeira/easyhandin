require 'rails_helper'

RSpec.describe Course, type: :model do
  it "has a valid factory" do
    expect(build(:course)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:course, name: nil)).to_not be_valid
  end

  it "is invalid without a slug" do
    expect(build(:course, slug: nil)).to_not be_valid
  end

  it "is invalid without a test_repository when published" do
    expect(build(:course, test_repository: nil, is_published: true)).to_not be_valid
  end
end
