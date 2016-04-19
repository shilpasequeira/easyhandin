class GetRepoBranches < ComposableOperations::Operation
  processes :org_name, :repo_name

  def execute
    Octokit.auto_paginate = true
    Octokit.client.branches(org_name + "/" + repo_name).collect{|branch| branch[:name]}
  end
end
