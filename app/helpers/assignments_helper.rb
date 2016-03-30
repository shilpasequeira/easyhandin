module AssignmentsHelper
  def processed_submission_test_results(submissions)
    submissions.map { |submission| { id: submission.id, test_result: submission.test_result.titleize } }.to_json
  end
end
