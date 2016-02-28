require 'rails_helper'

RSpec.describe "assignments/new", type: :view do
  before(:each) do
    assign(:assignment, Assignment.new(
      :name => "MyString",
      :slug => "MyString",
      :is_published => false,
      :is_team_mode => false,
      :bk_moss_build_id => 1,
      :bk_moss_job_id => 1,
      :moss_output => "MyText"
    ))
  end

  it "renders new assignment form" do
    render

    assert_select "form[action=?][method=?]", assignments_path, "post" do

      assert_select "input#assignment_name[name=?]", "assignment[name]"

      assert_select "input#assignment_slug[name=?]", "assignment[slug]"

      assert_select "input#assignment_is_published[name=?]", "assignment[is_published]"

      assert_select "input#assignment_is_team_mode[name=?]", "assignment[is_team_mode]"

      assert_select "input#assignment_bk_moss_build_id[name=?]", "assignment[bk_moss_build_id]"

      assert_select "input#assignment_bk_moss_job_id[name=?]", "assignment[bk_moss_job_id]"

      assert_select "textarea#assignment_moss_output[name=?]", "assignment[moss_output]"
    end
  end
end
