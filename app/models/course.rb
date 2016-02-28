class Course < ActiveRecord::Base
  has_many: instructors, class_name: 'User', foreign_key: "user_id"
  has_many: students, class_name: 'User', foreign_key: "user_id"
end
