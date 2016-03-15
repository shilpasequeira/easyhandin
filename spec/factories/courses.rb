FactoryGirl.define do
  factory :course do
    name "CPEN 221"
    slug "cpen-221"
    is_published false
    skeleton_repository "git@github.com:CPEN-221/example7.git"
    test_repository "git@github.com:CPEN-221/example7.git"

    after(:build) do |course|
      course.assignments << build(:assignment, :course => course)
      course.invites << build(:invite, :course => course)
    end

    after(:create) do |course|
      course.assignments.each { |assignment| assignment.save! }
      course.invites.each { |invites| invites.save! }
    end
  end
end
