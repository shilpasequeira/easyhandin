class GetOrganizations < ComposableOperations::Operation
  processes :access_token

  def execute
    client = Octokit::Client.new(:access_token => access_token)
    orgs = Array.new
    orgs += client.organizations
    last_response = client.last_response

    until last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
      orgs += last_response.data
    end

    # Returns a string array of organizations for client
    orgs.collect{|org| org[:login]}
  end
end
