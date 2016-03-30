class AddSubmissionRepoShaColumnToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :submission_repo_sha, :jsonb
  end
end
