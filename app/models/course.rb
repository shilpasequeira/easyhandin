class Course < ActiveRecord::Base
  has_many :assignments, dependent: :destroy

  has_many :course_instructors, dependent: :destroy
  has_many :instructors, through: :course_instructors, source: :user, after_remove: :delete_invitations

  has_many :course_students, dependent: :destroy
  has_many :students, through: :course_students, source: :user, after_remove: [:delete_invitations, :delete_from_team]

  has_many :invites, dependent: :destroy

  has_many :teams, dependent: :destroy

  validates :name, :org_name, presence: true

  validate :test_repository_cannot_be_nil_when_published

  EASYHANDIN_TEAM_NAME = "easyhandin"
  EASYHANDIN_USERNAME = "easyhandin"

  def create_test_skeleton_repos
    create_easyhandin_secret_team

    skeleton_repo_info = CreateRepository.perform(self.org_name, skeleton_repo_name_format, self.easyhandin_team_id)
    self.skeleton_repository = {name: skeleton_repo_info[:name], ssh_url: skeleton_repo_info[:ssh_url], html_url: skeleton_repo_info[:html_url]}

    test_repo_info = CreateRepository.perform(self.org_name, test_repo_name_format, self.easyhandin_team_id)
    self.test_repository = {name: test_repo_info[:name], ssh_url: test_repo_info[:ssh_url], html_url: test_repo_info[:html_url]}

    self.instructors.each do |instructor|
      AddCollaborator.perform(self.org_name, skeleton_repo_info[:name], instructor.username)
      AddCollaborator.perform(self.org_name, test_repo_info[:name], instructor.username)
    end

    self.save!
  end

  def create_student_repos
    create_easyhandin_secret_team

    self.course_students.where(repository: nil).each do |course_student|
      student = course_student.user
      student_repo_info = CreateRepository.perform(self.org_name, student_repo_name_format(student), self.easyhandin_team_id)

      self.course_students.find_by(user: student).update!(
        repository: {
          name: student_repo_info[:name],
          ssh_url: student_repo_info[:ssh_url],
          html_url: student_repo_info[:html_url]
        }
      )

      AddCollaborator.perform(self.org_name, student_repo_info[:name], student.username)
    end
  end

  def create_team_repos
    create_easyhandin_secret_team

    self.teams.where(repository: nil).each do |team|
      team_repo_info = CreateRepository.perform(self.org_name, team_repo_name_format(team), self.easyhandin_team_id)

      team.update!(
        repository: {
          name: team_repo_info[:name],
          ssh_url: team_repo_info[:ssh_url],
          html_url: team_repo_info[:html_url]
        }
      )

      team.users.each do |student|
        AddCollaborator.perform(self.org_name, team_repo_info[:name], student.username)
      end
    end
  end

  def create_easyhandin_secret_team
    if self.easyhandin_team_id.nil?
      self.easyhandin_team_id = CreateOrgTeam.perform(self.org_name, EASYHANDIN_TEAM_NAME, [EASYHANDIN_USERNAME])
      self.save!
    end
  end

  def test_repo_name_format
    "#{Date.today.year}-#{self.name.parameterize}-test_repository"
  end

  def skeleton_repo_name_format
    "#{Date.today.year}-#{self.name.parameterize}-skeleton_repository"
  end

  def student_repo_name_format(student)
    "#{Date.today.year}-#{self.name.parameterize}-#{student.username}"
  end

  def team_repo_name_format(team)
    "#{Date.today.year}-#{self.name.parameterize}-#{team.name.parameterize}"
  end

  def skeleton_branch_names
    GetRepoBranches.perform(self.org_name, self.skeleton_repository["name"])
  end

  def check_easyhandin_team_is_published
    self.easyhandin_team_id.present?
  end

  def check_test_repository_is_published
    self.test_repository.present?
  end

  def check_skeleton_repository_is_published
    self.skeleton_repository.present?
  end

  def check_team_repositories_is_published
    !self.teams.exists?(repository = nil)
  end

  def check_student_repositories_is_published
    !self.course_students.exists?(repository = nil)
  end

  def update_is_published
    if check_student_repositories_is_published &&
       check_team_repositories_is_published &&
       check_test_repository_is_published &&
       check_skeleton_repository_is_published &&
       check_easyhandin_team_is_published
      self.is_published = true
    else
      self.is_published = false
    end
    self.save!
  end

  protected

  def test_repository_cannot_be_nil_when_published
    if self.is_published? && test_repository.nil?
      errors.add(:test_repository, "can't be nil when course is published")
    end
  end

  def delete_invitations(user)
    self.invites.where(recipient: user).destroy_all
  end

  def delete_from_team(user)
    course_teams_with_user = self.teams.select {|team| team.users.include?(user)}
    course_teams_with_user.each do |team|
      team.users.delete(user)
    end
  end
end
