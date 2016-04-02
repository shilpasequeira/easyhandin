class AddMossResultColumnToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :moss_result, :integer
  end
end
