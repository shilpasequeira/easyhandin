class CreateBranch < ComposableOperations::Operation
  processes :client,
            :org_name,
            :repo_name,
            :branch_name

  def execute

    # Get ref of first commit
    ref = client.ref(org_name + "/" + repo_name, "heads/master")
    sha = ref[:object][:sha]

    # Create branch
    client.create_ref(org_name + "/" + repo_name, "heads/" + branch_name, sha)

  end
end