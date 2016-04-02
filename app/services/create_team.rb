class CreateTeam < ComposableOperations::Operation
  processes :client,
            :team_name,
            :org_name

  def execute

    # Does team already exist?
    teams = client.organization_teams(org_name)
    targetTeam = teams.select {|team| team["name"] == team_name }

    if (targetTeam.count > 0)
      return targetTeam.pop
    end

    return client.create_team(org_name, {:name => team_name})

  end
end