class GetCommitBeforeDeadline < ComposableOperations::Operation
  processes :org_name, :repo_name, :branch_name, :timestamp

  def execute
    Octokit.auto_paginate = true
    commits = Octokit.client.commits(org_name + "/" + repo_name, {:until => timestamp.to_time.iso8601, sha: branch_name})

    unless commits.blank?
      commits[0][:sha]
    end
  end
end
