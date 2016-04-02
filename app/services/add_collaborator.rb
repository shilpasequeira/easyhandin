class AddCollaborator < ComposableOperations::Operation
  processes :client,
            :org_name,
            :repo_name,
            :collaborator_username

  def execute

      client.add_collaborator(org_name + "/" + repo_name, collaborator_username)

  end
end
