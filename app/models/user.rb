class User < ActiveRecord::Base
  has_many :course_instructors
  has_many :teach_courses, through: :course_instructors, source: 'Course'

  has_many :course_students
  has_many :enrolled_courses, through: :course_students, source: 'Course'

  has_and_belongs_to_many :teams

  has_many :submissions, as: :submitter

  enum role: [ :instructor, :student ]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :student
  end

  def self.create_with_omniauth(auth, role)
    if user = User.find_by(uid: auth["uid"])
      user.access_token = auth["credentials"]["token"]
      return user
    else
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.name = auth["info"]["name"]
        user.email = auth["info"]["email"]
        user.username = auth["info"]["nickname"]
        user.access_token = auth["credentials"]["token"]
        user.role = role
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
