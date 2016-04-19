class CreateBranchBuild < ComposableOperations::Operation
  processes :skeleton_repo, :skeleton_branch_name, :branch_name, :submission_repos_json

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    client.create_build('easy-handin', 'create-submission-branches', {
      "commit": "HEAD",
      "branch": "master",
      "message": "Running submission branch creation build",
      "env": {
        "SKELETON_REPO": skeleton_repo,
        "SKELETON_BRANCH_NAME": skeleton_branch_name,
        "BRANCH_NAME": branch_name,
        "SUBMISSION_REPOS_JSON": submission_repos_json
      }
    })
  end
end
