class GetPrivateRepoCount < ComposableOperations::Operation
  processes :org_name

  def execute
    org = Octokit.client.organization(org_name)
    {:used => org[:total_private_repos], :capacity => org[:plan][:private_repos]}
  end
end
