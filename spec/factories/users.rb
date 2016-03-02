FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "john.doe@gmail.com"
    username "johndoe"
    role :student
    provider "github"
    uid "12345"

    factory :instructor do
      role :instructor
    end

    factory :student do
      role :student
    end
  end
end
