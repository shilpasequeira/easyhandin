class CreateTestBuild < ComposableOperations::Operation
  processes :course_repo, :branch_name, :grading_tests_repo, :sha
  property :message

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    client.create_build('easy-handin', 'test-maven-project', {
      "commit": "HEAD",
      "branch": "master",
      "message": message,
      "env": {
        "COURSE_REPO": course_repo,
        "BRANCH_NAME": branch_name,
        "GRADING_TESTS_REPO": grading_tests_repo,
        "SHA": sha
      }
    })
  end
end
