class CreateRepo < ComposableOperations::Operation
  processes :client,
            :repo_name,
            :org_name
            # :access_token

  property :private_repo, default: true, accepts: [true, false]
  property :description, default: "A generic description of the repo."
  property :auto_init_repo, default: true, accepts: [true, false]

  def execute

    # Does the repo already exist?
    repos = client.organization_repositories(org_name)
    targetRepo = repos.select {|repo| repo["name"] == repo_name }
    last_response = client.last_response

    until (last_response.rels[:next].nil? or targetRepo.count>0)
      last_response = last_response.rels[:next].get
      repos = last_response.data
      targetRepo = repos.select {|repo| repo["name"] == repo_name }
    end

    # Return existing repo
    if (targetRepo.count > 0)
      return targetRepo.pop
    end

    # Create new repo
    client.create_repository( repo_name,  { :organization => org_name,
                                           :private => private_repo,
                                           :description => description,
                                           :auto_init => auto_init_repo
                                          })
  end
end
