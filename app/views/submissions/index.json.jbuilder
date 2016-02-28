json.array!(@submissions) do |submission|
  json.extract! submission, :id, :grade, :feedback, :grading_test_output, :bk_test_build_id, :bk_test_job_id
  json.url submission_url(submission, format: :json)
end
