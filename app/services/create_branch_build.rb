class CreateBranchBuild < ComposableOperations::Operation
  processes :skeleton_repo, :branch_name, :submission_repos_url

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    client.create_build('easy-handin', 'create-submission-branches', '{
      "commit": "HEAD",
      "branch": "master",
      "message": "Running submission branch creation build",
      "env": {
        "SKELETON_REPO": "' + skeleton_repo + '",
        "BRANCH_NAME": "' + branch_name + '",
        "SUBMISSION_REPOS_URL": "' + submission_repos_url + '"
      }
    }')
  end
end
