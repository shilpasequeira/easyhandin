require 'rails_helper'

RSpec.describe "submissions/index", type: :view do
  before(:each) do
    assign(:submissions, [
      Submission.create!(
        :grade => 1,
        :feedback => "MyText",
        :grading_test_output => "MyText",
        :bk_test_build_id => 2,
        :bk_test_job_id => 3
      ),
      Submission.create!(
        :grade => 1,
        :feedback => "MyText",
        :grading_test_output => "MyText",
        :bk_test_build_id => 2,
        :bk_test_job_id => 3
      )
    ])
  end

  it "renders a list of submissions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
