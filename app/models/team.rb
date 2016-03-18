class Team < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :users
  has_many :submissions, as: :submitter

  after_create :create_team_submissions

  protected

  def create_team_submissions
    self.course.assignments.each do |assignment|
      if assignment.is_team_mode
        assignment.submissions.create(submitter: self)
      end
    end
  end
end
