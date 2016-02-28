json.array!(@assignments) do |assignment|
  json.extract! assignment, :id, :name, :slug, :is_published, :deadline, :grace_period, :is_team_mode, :bk_moss_build_id, :bk_moss_job_id, :moss_output
  json.url assignment_url(assignment, format: :json)
end
