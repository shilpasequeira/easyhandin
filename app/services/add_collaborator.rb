class AddCollaborator < ComposableOperations::Operation
  processes :org_name,
            :repo_name,
            :collaborator_username

  def execute
    Octokit.client.add_collaborator(org_name + "/" + repo_name, collaborator_username)
  end
end
