class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :submitter, polymorphic: true, index: true
      t.integer :grade
      t.text :feedback
      t.integer :test_result
      t.text :test_output
      t.integer :bk_test_build_id
      t.string :bk_test_job_id
      t.string :commit_sha
      t.belongs_to :assignment, index: true

      t.timestamps null: false
    end
  end
end
