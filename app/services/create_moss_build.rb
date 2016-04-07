class CreateMossBuild < ComposableOperations::Operation
  processes :submission_url
  property :message

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    client.create_build('easy-handin', 'moss-plagiarism-check', '{
      "commit": "HEAD",
      "branch": "master",
      "message": "Running moss build",
      "env": {
        "SUBMISSION_URL": "' + submission_url + '"
      }
    }')
  end
end
