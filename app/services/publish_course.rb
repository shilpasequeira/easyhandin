class PublishCourse < ComposableOperations::Operation
  processes :access_token,
            :org_name,
            :repo_users,
            :skeleton_repo,
            :tests_repo,
            :team_name

            # username_repos should look like this:

            # { repo_name: "student_repo_name", user_names: ["shilpasequeira"] },
            # { repo_name: "team_repo_name", user_names: ["shilpasequeira", "lexman"] }

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
    repo_users.each do |repo|
          CreateCourseRepo.perform(client, repo[:repo_name], org_name, repo[:user_names], team[:id])
    end

    return team[:id] #todo: create a new composable operation for teamname to teamid
  end
end