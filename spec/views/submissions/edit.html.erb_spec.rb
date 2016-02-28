require 'rails_helper'

RSpec.describe "submissions/edit", type: :view do
  before(:each) do
    @submission = assign(:submission, Submission.create!(
      :grade => 1,
      :feedback => "MyText",
      :grading_test_output => "MyText",
      :bk_test_build_id => 1,
      :bk_test_job_id => 1
    ))
  end

  it "renders the edit submission form" do
    render

    assert_select "form[action=?][method=?]", submission_path(@submission), "post" do

      assert_select "input#submission_grade[name=?]", "submission[grade]"

      assert_select "textarea#submission_feedback[name=?]", "submission[feedback]"

      assert_select "textarea#submission_grading_test_output[name=?]", "submission[grading_test_output]"

      assert_select "input#submission_bk_test_build_id[name=?]", "submission[bk_test_build_id]"

      assert_select "input#submission_bk_test_job_id[name=?]", "submission[bk_test_job_id]"
    end
  end
end
