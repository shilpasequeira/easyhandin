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

  SKELETON_REPO_NAME = "Skeleton_Repository"
  TEST_REPO_NAME = "Tests_Repository"
  EASYHANDIN_TEAM_NAME = "easyhandin"
  EASYHANDIN_USERNAME = "easyhandin"

  def publish(access_token)
    return unless !self.is_published

    client = Octokit::Client.new(:access_token => access_token)

    self.easyhandin_team_id = CreateGithubTeam.perform(client, org_name, EASYHANDIN_TEAM_NAME, [EASYHANDIN_USERNAME])

    skeleton_repo_info = CreateRepo.perform(client, org_name, SKELETON_REPO_NAME, self.easyhandin_team_id)
    self.skeleton_repository = skeleton_repo_info[:ssh_url]

    test_repo_info = CreateRepo.perform(client, org_name, TEST_REPO_NAME, self.easyhandin_team_id)
    self.test_repository = test_repo_info[:ssh_url]

    self.instructors.each do |instructor|
      AddCollaborator.perform(client, org_name, SKELETON_REPO_NAME, instructor.username)
      AddCollaborator.perform(client, org_name, TEST_REPO_NAME, instructor.username)
    end

    self.students.each do |student|
      student_repo_info = CreateRepo.perform(client, org_name, student_repo_name(student), self.easyhandin_team_id)
      self.course_students.find_by(user: student).update!(student_repository: student_repo_info[:ssh_url])
      AddCollaborator.perform(client, org_name, student_repo_name(student), student.username)
    end

    self.teams.each do |team|
      team_repo_info = CreateRepo.perform(client, org_name, team_repo_name(team), self.easyhandin_team_id)
      team.update!(repository: team_repo_info[:ssh_url])
      team.users.each do |student|
        AddCollaborator.perform(client, org_name, team_repo_name(team), student.username)
      end
    end

    self.is_published = true
    self.save!
  end

  def org_name
    self.slug
  end

  def student_repo_name(student)
    "#{Date.today.year}-#{student.username}"
  end

  def team_repo_name(team)
    "#{Date.today.year}-#{team.slug}"
  end

  protected

  def test_repository_cannot_be_nil_when_published
    if is_published.present? && test_repository.nil?
      errors.add(:test_repository, "can't be nil when course is published")
    end
  end
end
