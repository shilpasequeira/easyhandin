class AddCollaborator < ComposableOperations::Operation

  processes :course_name,
            :repo_name,
            :collaborator_github_username,
            :process_access_token

  def execute

    client = Octokit::Client.new(:access_token => process_access_token)
    client.add_collaborator(course_name + "/" + repo_name, collaborator_github_username)

   end
 end
 