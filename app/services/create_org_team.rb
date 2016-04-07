class CreateOrgTeam < ComposableOperations::Operation
  processes :org_name,
            :team_name,
            :members

  def execute
    org_teams = GetOrgTeams.perform(org_name)

    team = org_teams.find {|org_team| org_team["name"] == team_name}
    if team.nil?    
      team = Octokit.client.create_team(org_name, {:name => team_name})
    end

    members.each do |username|
      Octokit.client.add_team_membership(team[:id], username)
    end

    team[:id]
  end
end
