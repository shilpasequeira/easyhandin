class GetOrgRepositories < ComposableOperations::Operation
  processes :org_name

  def execute
    Octokit.auto_paginate = true
    Octokit.client.organization_repositories(org_name)
  end
end
