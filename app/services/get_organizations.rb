class GetOrganizations < ComposableOperations::Operation
  def execute
    Octokit.auto_paginate = true
    Octokit.client.organizations.collect{|org| org[:login]}
  end
end
