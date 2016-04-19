class Team < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :users
  has_many :submissions, as: :submitter, dependent: :destroy

  after_create :create_team_submissions
  after_create :unpublish_course

  protected

  def create_team_submissions
    self.course.assignments.each do |assignment|
      if assignment.is_team_mode
        assignment.submissions.create(submitter: self)
      end
    end
  end

  def unpublish_course
    self.course.unpublish_course
  end
end
