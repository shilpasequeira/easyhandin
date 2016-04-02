class PublishCourse < ComposableOperations::Operation
  processes :access_token,
            :org_name,
            :username_repos,
            :skeleton_repo,
            :tests_repo,
            :team_name

            # username_repos should look like this:
                # hash1 = { :username => "lexman34", :repo => "EA_Repo1" }
                # hash2 = { :username => "shilpasequeira", :repo => "EA_Repo2"}
                
                # username_repos = []
                # username_repos.push(hash1)
                # username_repos.push(hash2)

  def execute

    # Setup
    client = Octokit::Client.new(:access_token => access_token)

    # Create secret team
    team = CreateTeam.perform(client, team_name, org_name)
    # Add easyhandin to this team
    AddTeamMember.perform(client, team[:id], "easyhandin")

    # Create skeleton repo
    CreateRepo.perform(client, skeleton_repo, org_name)
    AddTeamRepo.perform(client, team[:id], org_name + "/" + skeleton_repo)

    # Create tests repo
    CreateRepo.perform(client, tests_repo, org_name)
    AddTeamRepo.perform(client, team[:id], org_name + "/" + tests_repo)

    #Add Student Repos
    username_repos.each do |username_repo|
      CreateRepo.perform(client, username_repo[:repo], org_name)
      AddCollaborator.perform(client, org_name, username_repo[:repo], username_repo[:username])
      AddTeamRepo.perform(client, team[:id], org_name + "/" + username_repo[:repo])
    end

  end
end