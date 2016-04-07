class GetOrgTeams < ComposableOperations::Operation
  processes :org_name

  def execute
    Octokit.auto_paginate = true
    Octokit.client.organization_teams(org_name)
  end
end
