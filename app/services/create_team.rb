class CreateTeam < ComposableOperations::Operation
  processes :client,
            :team_name,
            :org_name

  def execute

    # Does team already exist?
    teams = client.organization_teams(org_name)
    targetTeam = teams.select {|team| team["name"] == team_name }
    last_response = client.last_response

    until (last_response.rels[:next].nil? or targetTeam.count>0)
      last_response = last_response.rels[:next].get
      teams = last_response.data
      targetTeam = teams.select {|team| team["name"] == team_name }
    end

    # Return existing team
    if (targetTeam.count > 0)
      return targetTeam.pop
    end

    # Create new team
    client.create_team(org_name, {:name => team_name})

  end
end