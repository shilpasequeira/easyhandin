class Course < ActiveRecord::Base
  has_many :assignments, dependent: :destroy

  has_many :course_instructors, dependent: :destroy
  has_many :instructors, through: :course_instructors, source: :user

  has_many :course_students, dependent: :destroy
  has_many :students, through: :course_students, source: :user

  has_many :invites, dependent: :destroy

  has_many :teams, dependent: :destroy

  validates :name, :org_name, presence: true

  validate :test_repository_cannot_be_nil_when_published

  SKELETON_REPO_NAME = "Skeleton_Repository"
  TEST_REPO_NAME = "Tests_Repository"
  EASYHANDIN_TEAM_NAME = "easyhandin"
  EASYHANDIN_USERNAME = "easyhandin"

  def create_test_skeleton_repos
    create_easyhandin_secret_team

    skeleton_repo_info = CreateRepository.perform(self.org_name, SKELETON_REPO_NAME, self.easyhandin_team_id)
    self.skeleton_repository = {ssh_url: skeleton_repo_info[:ssh_url], html_url: skeleton_repo_info[:html_url]}

    test_repo_info = CreateRepository.perform(self.org_name, TEST_REPO_NAME, self.easyhandin_team_id)
    self.test_repository = {ssh_url: test_repo_info[:ssh_url], html_url: test_repo_info[:html_url]}

    self.instructors.each do |instructor|
      AddCollaborator.perform(self.org_name, SKELETON_REPO_NAME, instructor.username)
      AddCollaborator.perform(self.org_name, TEST_REPO_NAME, instructor.username)
    end

    self.save!
  end

  def create_student_repos
    create_easyhandin_secret_team

    self.course_students.where(repository: nil).each do |course_student|
      student = course_student.user
      student_repo_info = CreateRepository.perform(self.org_name, student_repo_name(student), self.easyhandin_team_id)

      self.course_students.find_by(user: student).update!(
        repository: {
          ssh_url: student_repo_info[:ssh_url],
          html_url: student_repo_info[:html_url]
        }
      )

      AddCollaborator.perform(self.org_name, student_repo_name(student), student.username)
    end
  end

  def create_team_repos
    create_easyhandin_secret_team

    self.teams.where(repository: nil).each do |team|
      team_repo_info = CreateRepository.perform(self.org_name, team_repo_name(team), self.easyhandin_team_id)

      team.update!(
        repository: {
          ssh_url: team_repo_info[:ssh_url],
          html_url: team_repo_info[:html_url]
        }
      )

      team.users.each do |student|
        AddCollaborator.perform(self.org_name, team_repo_name(team), student.username)
      end
    end
  end

  def create_easyhandin_secret_team
    if self.easyhandin_team_id.nil?
      self.easyhandin_team_id = CreateOrgTeam.perform(self.org_name, EASYHANDIN_TEAM_NAME, [EASYHANDIN_USERNAME])
      self.save!
    end
  end

  def student_repo_name(student)
    "#{Date.today.year}-#{student.username}"
  end

  def team_repo_name(team)
    "#{Date.today.year}-#{team.name.parameterize}"
  end

  protected

  def test_repository_cannot_be_nil_when_published
    if is_published.present? && test_repository.nil?
      errors.add(:test_repository, "can't be nil when course is published")
    end
  end
end
