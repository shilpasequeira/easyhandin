class Course < ActiveRecord::Base
  has_many :assignments, dependent: :destroy

  has_many :course_instructors, dependent: :destroy
  has_many :instructors, through: :course_instructors, source: :user

  has_many :course_students, dependent: :destroy
  has_many :students, through: :course_students, source: :user

  has_many :invites, dependent: :destroy

  has_many :teams, dependent: :destroy

  validates :name, :slug, presence: true

  validate :test_repository_cannot_be_nil_when_published

  protected

  def test_repository_cannot_be_nil_when_published
    if is_published.present? && test_repository.nil?
      errors.add(:test_repository, "can't be nil when course is published")
    end
  end
end
