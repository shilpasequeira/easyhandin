class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :submitter, polymorphic: true

  enum test_result: [ :passed, :failed, :error, :in_progress ]

  def repository
    if self.submitter_type == "Team"
      self.submitter.repository
    else
      self.submitter.course_students.find_by(course: self.assignment.course).student_repository
    end
  end
end
