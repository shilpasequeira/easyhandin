class Course < ActiveRecord::Base
  has_many :assignments

  has_many :course_instructors
  has_many :instructors, through: :course_instructors, source: 'User'

  has_many :course_students
  has_many :students, through: :course_students, source: 'User'

  has_many :teams
end
