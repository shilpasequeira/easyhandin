class GetPrivateRepoCount < ComposableOperations::Operation
  processes :client,
            :org_name

  def execute

    # Get organization sawyer
    org = client.organization(org_name)

    # Return private repo info
    private_repos = { :used => org[:total_private_repos],
                      :capacity => org[:plan][:private_repos]
                    }
                    
  end
end