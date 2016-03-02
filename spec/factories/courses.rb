FactoryGirl.define do
  factory :course do
    name "ICICS 504"
    slug "icics-504"
    is_published false
    skeleton_repository "git@github.com:CPEN-221/example7.git"
    test_repository "git@github.com:CPEN-221/example7.git"
  end
end
