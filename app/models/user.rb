class User < ActiveRecord::Base
  has_many :course_instructors, dependent: :destroy
  has_many :teach_courses, through: :course_instructors, source: :course

  has_many :course_students, dependent: :destroy
  has_many :enrolled_courses, through: :course_students, source: :course

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  has_and_belongs_to_many :teams

  has_many :submissions, as: :submitter

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
    self.university_id = invite.university_id if invite.university_id.present?

    if self.instructor? && !self.teach_courses.include?(invite.course)
      self.teach_courses.push(invite.course)
    elsif !self.enrolled_courses.include?(invite.course)
      self.enrolled_courses.push(invite.course)
    end
  end
end
