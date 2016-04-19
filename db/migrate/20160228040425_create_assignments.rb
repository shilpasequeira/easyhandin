class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.string :branch_name
      t.string :skeleton_branch_name
      t.boolean :is_published, default: false
      t.datetime :deadline
      t.datetime :grace_period
      t.boolean :is_team_mode, default: false
      t.integer :bk_moss_build_id
      t.string :bk_moss_job_id
      t.integer :moss_result
      t.text :moss_output
      t.integer :language
      t.jsonb :moss_build_submissions
      t.jsonb :branch_build_submissions
      t.belongs_to :course, index: true

      t.timestamps null: false
    end
  end
end
