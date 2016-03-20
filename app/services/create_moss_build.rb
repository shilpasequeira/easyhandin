class CreateMossBuild < ComposableOperations::Operation
  property :message

  def execute
    begin
      client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
      response = client.create_build('easy-handin', 'moss-plagiarism-check', '{
        "commit": "HEAD",
        "branch": "master",
        "message": "Running moss build"
      }')
      response
    rescue => e
      Rails.logger.error {
        "Error when trying to create a moss build for repository : , #{e.message} #{e.backtrace.join("\n")}"
      }
      nil
    end
  end
end
