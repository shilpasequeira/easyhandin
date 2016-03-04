class CreateOrganization < ComposableOperations::Operation

  processes :org_username,
            :org_display_name,
            :org_admin_login

  def execute

    client = Octokit::Client.new(:access_token => session[:access_token])
    client.create_organization(org_username, org_admin_login, :profile_name => org_display_name)
    
  end
end