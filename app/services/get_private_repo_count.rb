class GetPrivateRepoCount < ComposableOperations::Operation
  processes :client, :org_name

  def execute
    org = client.organization(org_name)
    {:used => org[:total_private_repos], :capacity => org[:plan][:private_repos]}
  end
end
