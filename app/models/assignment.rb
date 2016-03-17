class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions, dependent: :destroy

  validates :name, :slug, :course_id, presence: true
  validate :test_deadline_cannot_be_nil_when_published, :test_grace_period_cannot_be_before_deadline

  after_create :create_submissions

  protected

  def create_submissions
    if self.is_team_mode
      self.course.teams.each do |team|
        self.submissions.create(submitter: team)
      end
    else
      self.course.students.each do |student|
        self.submissions.create(submitter: student)
      end
    end
  end

  def test_grace_period_cannot_be_before_deadline
    if deadline.present? && grace_period.present? && (grace_period < deadline)
      errors.add(:grace_period, "can't be before the deadline")
    end
  end

  def test_deadline_cannot_be_nil_when_published
    if is_published.present? && deadline.nil?
      errors.add(:deadline, "can't be nil when assignment is published")
    end
  end
end
