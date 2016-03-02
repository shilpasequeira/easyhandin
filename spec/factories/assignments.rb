FactoryGirl.define do
  factory :assignment do
    name "Assignment 1"
    slug "assignment-1"
    is_published false
    deadline "2016-02-12 21:40:24"
    grace_period "2016-02-13 21:40:24"
    is_team_mode false
    bk_moss_build_id nil
    bk_moss_job_id nil
    moss_output "MyText"
    course
  end
end
