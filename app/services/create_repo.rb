class CreateRepo < ComposableOperations::Operation
  processes :repo_name,
            :org_name,
            :access_token

  property :private_repo, default: true, accepts: [true, false]
  property :description, default: "A generic description of the repo."
  property :auto_init_repo, default: true, accepts: [true, false]

  def execute
    client = Octokit::Client.new(:access_token => access_token)
    response = client.create_repository(
      repo_name,
      {
        :organization => org_name,
        :private => private_repo,
        :description => description,
        :auto_init => auto_init_repo
      }
    )
    response
  end
end
