class CreateRepository < ComposableOperations::Operation
  processes :org_name,
            :repo_name,
            :team_id

  property :private_repo, default: true, accepts: [true, false]
  property :description, default: "A generic description of the repo."
  property :auto_init_repo, default: true, accepts: [true, false]

  def execute
    org_repos = GetOrgRepositories.perform(org_name)
    repository = org_repos.find {|org_repo| org_repo["name"] == repo_name}

    if repository.nil?
      repository = Octokit.client.create_repository(
        repo_name,
        {
          :organization => org_name,
          :private => private_repo,
          :description => description,
          :auto_init => auto_init_repo
        }
      )
    end

    Octokit.client.add_team_repository(team_id, org_name + "/" + repo_name, :permission => 'push')

    repository
  end
end
