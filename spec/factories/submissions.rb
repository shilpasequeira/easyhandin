FactoryGirl.define do
  factory :submission do
    grade 88
    feedback Faker::Hacker.say_something_smart
    grading_test_output "MyText"
    bk_test_build_id 12
    bk_test_job_id "12mfj3l"
    association :submitter, factory: :student
    assignment

    factory :student_submission, class: "User" do
      association :submitter, factory: :student
    end

    factory :team_submission, class: "Team" do
      association :submitter, factory: :team
    end
  end
end
