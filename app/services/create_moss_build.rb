class CreateMossBuild < ComposableOperations::Operation
  property :message

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    response = client.create_build('easy-handin', 'moss-plagiarism-check', '{
      "commit": "HEAD",
      "branch": "master",
      "message": "Running moss build"
    }')
    response
  end
end
