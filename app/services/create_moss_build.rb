class CreateMossBuild < ComposableOperations::Operation
  processes :skeleton_repo, :branch_name, :language, :file_extension, :submission_json
  property :message

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    client.create_build('easy-handin', 'moss-plagiarism-check', {
      "commit": "HEAD",
      "branch": "master",
      "message": "Running moss build",
      "env": {
        "SKELETON_REPO": skeleton_repo,
        "BRANCH_NAME": branch_name,
        "LANGUAGE": language,
        "FILE_EXTENSION": file_extension,
        "SUBMISSION_JSON": submission_json
      }
    })
  end
end
