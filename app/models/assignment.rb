class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :submissions, dependent: :destroy

  validates :name, :branch_name, :course_id, :language, presence: true
  validate :test_deadline_cannot_be_nil_when_published, :test_grace_period_cannot_be_before_deadline

  after_create :create_submissions

  enum moss_result: [ :finished, :error, :in_progress ]
  enum language: [ :java ]

  def file_extension
    file_extensions = { java: "java" }
    file_extensions[self.language.to_sym]
  end

  def run_tests(submissions)
    submissions.each do |submission|
      submission.test
    end
  end

  def run_moss(submissions)
    submission_repo_sha = []

    submissions.each do |submission|
      submission_repo_sha.push({repo: submission.repository["ssh_url"], sha: submission.commit_sha})
    end

    self.submission_repo_sha = submission_repo_sha.to_json
    self.save!

    response = CreateMossBuild.perform(Rails.application.routes.url_helpers.submission_repo_sha_url(self))
    self.bk_moss_build_id =  response["number"]
    self.bk_moss_job_id = response["jobs"][0]["id"]
    self.moss_output = nil
    self.moss_result = "in_progress"
    self.save!
  end

  def update_moss_output
    if self.bk_moss_build_id.present? && self.bk_moss_job_id.present? && self.moss_output.nil?
      response = MossBuildJobParser.perform(self.bk_moss_build_id, self.bk_moss_job_id)
      self.moss_result = response["status"]
      self.moss_output = response["content"]
      self.save!
    end
  end

  def branch_url(repository)
    if repository.present?
      "#{repository["html_url"]}/tree/#{self.branch_name}"
    end
  end

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
