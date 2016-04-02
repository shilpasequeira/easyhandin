class AddTeamMember < ComposableOperations::Operation
  processes :client,
			:team_id,
			:gh_user
            
  def execute

	client.add_team_membership(team_id, gh_user)

  end
end
