class User < ActiveRecord::Base
  has_many :course_instructors, dependent: :destroy
  has_many :teach_courses, through: :course_instructors, source: :course

  has_many :course_students, dependent: :destroy
  has_many :enrolled_courses, through: :course_students, source: :course, after_add: [:create_student_submissions, :unpublish_course]

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  has_and_belongs_to_many :teams

  has_many :submissions, as: :submitter, dependent: :destroy

  enum role: [ :instructor, :student ]

  after_initialize :set_default_role, :if => :new_record?

  validates :email, :username, :provider, :uid, :role, presence: true

  def set_default_role
    self.role ||= :student
  end

  def self.create_with_omniauth(auth, role)
    if user = User.find_by(uid: auth["uid"])
      return user
    else
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"]
        user.username = auth["info"]["nickname"]
        user.role = role
      end
    end
  end

  def complete_invitation(invite)
    invite.is_accepted = true
    invite.save!

    self.name = invite.name if invite.name.present?
    self.university_id = invite.university_id if invite.university_id.present?

    if self.instructor? && !self.teach_courses.include?(invite.course)
      self.teach_courses.push(invite.course)
    elsif !self.enrolled_courses.include?(invite.course)
      self.enrolled_courses.push(invite.course)
    end

    if invite.team_number.present?
      team = Team.find_by(name: "Team #{invite.team_number}", course_id: invite.course.id)

      if team.nil?
        team = Team.create(name: "Team #{invite.team_number}", course_id: invite.course.id)
      end

      team.users.push(self)
    end

    self.save!
  end

  def create_student_submissions(course)
    course.assignments.each do |assignment|
      if !assignment.is_team_mode
        assignment.submissions.create!(submitter: self)
      end
    end
  end

  def unpublish_course(course)
    course.unpublish_course
  end

  def courses
    if self.role == "instructor"
      self.teach_courses
    else
      self.enrolled_courses
    end
  end

  def repository(course)
    if self.student?
      self.course_students.find_by(course: course).repository
    end
  end
end
