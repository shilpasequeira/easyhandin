FactoryGirl.define do
  factory :team do
    name Faker::Team.name
    slug Faker::Internet.slug
    repository "git@github.com:UBC-EECE514/group6.git"
  end
end
