require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it "has a valid factory" do
    expect(build(:assignment)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:assignment, name: nil)).to_not be_valid
  end

  it "is invalid without a slug" do
    expect(build(:assignment, slug: nil)).to_not be_valid
  end

  it "is invalid without a deadline when published" do
    expect(build(:assignment, deadline: nil, is_published: true)).to_not be_valid
  end

  it "is invalid when grace period is before the deadline" do
    expect(build(:assignment, grace_period: '2016-02-11 21:40:24', deadline: '2016-02-12 21:40:24')).to_not be_valid
  end

  it "is invalid without a course" do
    expect(build(:assignment, course: nil)).to_not be_valid
  end
end
