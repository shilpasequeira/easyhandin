FactoryGirl.define do
  factory :submission do
    grade 88
    feedback "MyText"
    grading_test_output "MyText"
    bk_test_build_id 12
    bk_test_job_id 13
  end
end
