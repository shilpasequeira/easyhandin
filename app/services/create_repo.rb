class CreateRepo < ComposableOperations::Operation

  processes :process_repo_name,
            :process_org_name,
            :process_access_token

  property :property_private, default: "true"
  property :property_description, default: "A generic description of the repo."
  property :property_auto_init, default: true,
                                accepts: [true, false]

  def execute

    client = Octokit::Client.new(:access_token => process_access_token)
    client.create_repository(process_repo_name, {:organization => process_org_name,
                                                 :private => property_private, 
                                                 :description => property_description,
                                                 :auto_init => property_auto_init})

   end
 end