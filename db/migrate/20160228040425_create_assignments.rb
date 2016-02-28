class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.string :slug
      t.boolean :is_published
      t.datetime :deadline
      t.datetime :grace_period
      t.boolean :is_team_mode
      t.integer :bk_moss_build_id
      t.integer :bk_moss_job_id
      t.text :moss_output
      t.belongs_to :course

      t.timestamps null: false
    end
  end
end