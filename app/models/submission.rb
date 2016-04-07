class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :submitter, polymorphic: true

  enum test_result: [ :passed, :failed, :error, :in_progress ]

  def repository
    if self.assignment.is_team_mode
      self.submitter.repository
    else
      self.submitter.repository(self.assignment.course)
    end
  end

  def test
    response = CreateTestBuild.perform(
      self.repository["ssh_url"],
      self.assignment.branch_name,
      self.assignment.course.test_repository["ssh_url"],
      message: "Creating build for assignment #{self.assignment.course.name} - #{self.assignment.name} by #{self.submitter.name}"
    )

    self.test_result = "in_progress"
    self.test_output = nil
    self.bk_test_build_id = response["number"]
    self.bk_test_job_id = response["jobs"][0]["id"]

    self.save!
  end

  def update_test_output
    return unless self.test_output.nil?
    return unless self.bk_test_build_id.present? && self.bk_test_job_id.present?

    response = TestBuildJobParser.perform(
      self.bk_test_build_id,
      self.bk_test_job_id
    )

    if Submission.test_results.keys.to_a.include?(response["status"])
      self.test_result = response["status"]
    else
      self.test_result = "error"
    end

    self.test_output = response["content"]
    self.save!
  end
end
