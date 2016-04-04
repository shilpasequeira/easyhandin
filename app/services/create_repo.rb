class CreateRepo < ComposableOperations::Operation
  processes :client,
            :org_name,
            :repo_name,
            :team_id

  property :private_repo, default: true, accepts: [true, false]
  property :description, default: "A generic description of the repo."
  property :auto_init_repo, default: true, accepts: [true, false]

  def execute
    repos = client.organization_repositories(org_name)
    target_repo = repos.select {|repo| repo["name"] == repo_name}
    last_response = client.last_response

    until (last_response.rels[:next].nil? or target_repo.count > 0)
      last_response = last_response.rels[:next].get
      repos = last_response.data
      target_repo = repos.select {|repo| repo["name"] == repo_name}
    end

    # Return existing repo
    if (target_repo.count > 0)
      repository = target_repo.pop
      client.add_team_repository(team_id, repository)
    else
      repository = client.create_repository(repo_name, {:organization => org_name,
                                                        :private => private_repo,
                                                        :description => description,
                                                        :auto_init => auto_init_repo,
                                                        :team_id => team_id
                                                       })
    end

    repository
  end
end
