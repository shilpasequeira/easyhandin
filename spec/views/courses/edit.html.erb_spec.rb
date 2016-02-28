require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :name => "MyString",
      :slug => "MyString",
      :is_published => false,
      :test_repository => "MyString"
    ))
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_slug[name=?]", "course[slug]"

      assert_select "input#course_is_published[name=?]", "course[is_published]"

      assert_select "input#course_test_repository[name=?]", "course[test_repository]"
    end
  end
end
