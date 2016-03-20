class AddCollaborator < ComposableOperations::Operation
  processes :repo_name,
            :collaborator_username,
            :access_token

  def execute
    begin
      client = Octokit::Client.new(:access_token => access_token)
      client.add_collaborator(repo_name, collaborator_username)
    rescue => e
      Rails.logger.error {
        "Error when trying to add #{collaborator_username} as a collaborator to repository : #{repo_name}, #{e.message} #{e.backtrace.join("\n")}"
      }
      nil
    end
  end
end
