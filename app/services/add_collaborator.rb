class AddCollaborator < ComposableOperations::Operation
  processes :repo_name,
            :collaborator_username,
            :access_token

  def execute
    client = Octokit::Client.new(:access_token => access_token)
    client.add_collaborator(repo_name, collaborator_username)
  end
end
