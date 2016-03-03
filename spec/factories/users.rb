FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    username Faker::Internet.user_name
    role :student
    provider "github"
    uid Faker::Number.number(5)

    factory :instructor do
      role :instructor
    end

    factory :student do
      role :student
    end
  end
end
