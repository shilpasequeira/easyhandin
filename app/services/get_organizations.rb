class GetOrganizations < ComposableOperations::Operation
  processes :client,

  # Returns a string array of organizations for client
  def execute

    # Get all organizations for this user
    orgs = Array.new
    orgs += client.organizations
    last_response = client.last_response
    until last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
      orgs += last_response.data
    end

    # Return array of organization names
    org_names = Array.new
    org_names = orgs.collect{|org| org[:login]}

  end
end