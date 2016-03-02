class Course < ActiveRecord::Base
  has_many :assignments

  has_many :course_instructors
  has_many :instructors, through: :course_instructors, source: 'User'

  has_many :course_students
  has_many :students, through: :course_students, source: 'User'

  has_many :teams

  validates :name, :slug, presence: true

  validate :test_repository_cannot_be_nil_when_published

  def test_repository_cannot_be_nil_when_published
    if is_published.present? && test_repository.nil?
      errors.add(:test_repository, "can't be nil when course is published")
    end
  end
end
