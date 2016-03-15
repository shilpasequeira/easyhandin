require 'rails_helper'

RSpec.describe Invite, type: :model do
  it "has a valid factory" do
    expect(build(:invite)).to be_valid
  end
end
