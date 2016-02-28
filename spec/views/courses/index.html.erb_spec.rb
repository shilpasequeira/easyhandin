require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        :name => "Name",
        :slug => "Slug",
        :is_published => false,
        :test_repository => "Test Repository"
      ),
      Course.create!(
        :name => "Name",
        :slug => "Slug",
        :is_published => false,
        :test_repository => "Test Repository"
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Test Repository".to_s, :count => 2
  end
end
