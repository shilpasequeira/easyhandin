FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    username Faker::Internet.user_name
    role :student
    provider "github"
    sequence(:uid)

    factory :instructor do
      role :instructor
    end

    factory :student do
      role :student
    end
  end
end
