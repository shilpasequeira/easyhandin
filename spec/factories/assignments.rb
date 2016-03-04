FactoryGirl.define do
  factory :assignment do
    name "Assignment 1"
    slug "assignment-1"
    is_published false
    deadline "2016-02-12 21:40:24"
    grace_period "2016-02-13 21:40:24"
    is_team_mode false
    bk_moss_build_id 1
    bk_moss_job_id "34efd"
    moss_output "MyText"
    course

    after(:build) do |assignment|
      assignment.submissions << build(:submission, assignment: assignment)
    end

    after(:create) do |assignment|
      assignment.submissions.each { |submissions| submissions.save! }
    end
  end
end
