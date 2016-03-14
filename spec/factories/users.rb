FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    username Faker::Internet.user_name
    role :student
    provider "github"
    sequence(:uid)
    university_id Faker::Lorem.characters(10)

    factory :instructor do
      role :instructor
    end

    factory :student do
      role :student
    end
  end
end
