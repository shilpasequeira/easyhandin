FactoryGirl.define do
  factory :invite do
    user_role :student
    email Faker::Internet.email
    university_id Faker::Lorem.characters(10)
    token Faker::Lorem.characters(10)
    association :sender, factory: :instructor
    course

    factory :invite_instructor do
      user_role :instructor
    end

    factory :invite_student do
      user_role :student
    end
  end
end
