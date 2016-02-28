require 'rails_helper'

RSpec.describe "courses/new", type: :view do
  before(:each) do
    assign(:course, Course.new(
      :name => "MyString",
      :slug => "MyString",
      :is_published => false,
      :test_repository => "MyString"
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_slug[name=?]", "course[slug]"

      assert_select "input#course_is_published[name=?]", "course[is_published]"

      assert_select "input#course_test_repository[name=?]", "course[test_repository]"
    end
  end
end
