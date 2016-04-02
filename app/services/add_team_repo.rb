class AddTeamRepo < ComposableOperations::Operation
  processes :client,
			:team_id,
			:repo
            

  def execute

	client.add_team_repository(team_id, repo)

  end
end

