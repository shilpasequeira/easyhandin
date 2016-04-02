class PublishCourse < ComposableOperations::Operation
  processes :access_token 


  def execute


    # Setup
    client = Octokit::Client.new(:access_token => access_token)

    orgName = "CPEN-221"
    collaborator = "Lexman34"
    skeletonRepo = "0EA_Skeleton"
    testRepo = "0EA_Tests"
    teamName = "0EATEAM"

    hash1 = { :username => "lexman34", :repo => "EA_Repo1" }
    hash2 = { :username => "shilpasequeira", :repo => "EA_Repo2"}
    
    username_repos = []
    username_repos.push(hash1)
    username_repos.push(hash2)
    

    # Create secret team
    team = CreateTeam.perform(client, teamName, orgName)
    # Add easyhandin to this team
    AddTeamMember.perform(client, team[:id], "easyhandin")

    # Create skeleton repo
    CreateRepo.perform(client, skeletonRepo, orgName)
    AddTeamRepo.perform(client, team[:id], orgName + "/" + skeletonRepo)

    # Create tests repo
    CreateRepo.perform(client, testRepo, orgName)
    AddTeamRepo.perform(client, team[:id], orgName + "/" + testRepo)


    #Add Student Repos
    # binding.pry
    username_repos.each do |username_repo|
      CreateRepo.perform(client, username_repo[:repo], orgName)
      AddCollaborator.perform(client, orgName, username_repo[:repo], username_repo[:username])     
    end


  end
end