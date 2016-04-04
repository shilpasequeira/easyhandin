class CreateGithubTeam < ComposableOperations::Operation
  processes :client,
            :org_name,
            :team_name,
            :members

  def execute
    # Does team already exist?
    teams = client.organization_teams(org_name)
    target_team = teams.select {|team| team["name"] == team_name}
    last_response = client.last_response

    until (last_response.rels[:next].nil? or target_team.count > 0)
      last_response = last_response.rels[:next].get
      teams = last_response.data
      target_team = teams.select {|team| team["name"] == team_name }
    end

    if (target_team.count > 0)
      # Return existing team
      team = target_team.pop
    else
      # Create new team
      team = client.create_team(org_name, {:name => team_name})
    end

    members.each do |username|
      client.add_team_membership(team[:id], username)
    end

    team[:id]
  end
end
