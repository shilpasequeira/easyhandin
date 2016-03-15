FactoryGirl.define do
  factory :submission do
    grade 88
    feedback Faker::Hacker.say_something_smart
    test_result :passed
    test_output Faker::Lorem.paragraphs
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
