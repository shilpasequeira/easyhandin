class CreateBranch < ComposableOperations::Operation
  processes :org_name, :repo_name, :branch_name

  def execute
    repo_branches = GetRepoBranches.perform(org_name, repo_name)

    unless repo_branches.include?(branch_name)
      ref = Octokit.client.ref(org_name + "/" + repo_name, "heads/master")
      sha = ref[:object][:sha]
      Octokit.client.create_ref(org_name + "/" + repo_name, "heads/" + branch_name, sha)
    end
  end
end
