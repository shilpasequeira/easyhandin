class GetCommitBeforeDeadlineJob < ActiveJob::Base
  queue_as :default

  def perform(assignment)
    return if assignment.final_deadline.future?

    assignment.submissions.each do |submission|
      submission.commit_sha = GetCommitBeforeDeadline.perform(
        assignment.course.org_name, 
        submission.repo_name, 
        assignment.branch_name, 
        assignment.final_deadline
      )
      submission.save!
    end
  end
end
