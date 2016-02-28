require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    assign(:teams, [
      Team.create!(
        :name => "Name",
        :slug => "Slug",
        :repository => "Repository"
      ),
      Team.create!(
        :name => "Name",
        :slug => "Slug",
        :repository => "Repository"
      )
    ])
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "Repository".to_s, :count => 2
  end
end
