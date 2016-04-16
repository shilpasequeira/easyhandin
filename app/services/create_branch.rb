class CreateBranch < ComposableOperations::Operation
  processes :org_name, :repo_name, :branch_name

  def execute
    ref = Octokit.client.ref(org_name + "/" + repo_name, "heads/master")
    sha = ref[:object][:sha]
    Octokit.client.create_ref(org_name + "/" + repo_name, "heads/" + branch_name, sha)
  end
end
