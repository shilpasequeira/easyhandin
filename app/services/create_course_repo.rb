class CreateCourseRepo < ComposableOperations::Operation
  processes :client,
            :repo_name,
            :org_name,
            :collaborators,
            :team_id

  def execute

      CreateRepo.perform(client, repo_name, org_name)
      collaborators.each do |collaborator|
        AddCollaborator.perform(client, org_name, repo_name, collaborator)
      end
      AddTeamRepo.perform(client, team_id, org_name + "/" + repo_name)

  end
end