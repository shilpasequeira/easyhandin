class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :submitter, polymorphic: true, index: true
      t.integer :grade
      t.text :feedback
      t.text :grading_test_output
      t.integer :bk_test_build_id
      t.integer :bk_test_job_id
      t.belongs_to :assignment, index: true

      t.timestamps null: false
    end
  end
end