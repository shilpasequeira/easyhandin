require 'rails_helper'

RSpec.describe "assignments/index", type: :view do
  before(:each) do
    assign(:assignments, [
      Assignment.create!(
        :name => "Name",
        :slug => "Slug",
        :is_published => false,
        :is_team_mode => false,
        :bk_moss_build_id => 1,
        :bk_moss_job_id => 2,
        :moss_output => "MyText"
      ),
      Assignment.create!(
        :name => "Name",
        :slug => "Slug",
        :is_published => false,
        :is_team_mode => false,
        :bk_moss_build_id => 1,
        :bk_moss_job_id => 2,
        :moss_output => "MyText"
      )
    ])
  end

  it "renders a list of assignments" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
