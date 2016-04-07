class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :org_name
      t.jsonb :test_repository
      t.jsonb :skeleton_repository
      t.boolean :is_published, default: false
      t.integer :easyhandin_team_id

      t.timestamps null: false
    end

    create_table :course_instructors do |t|
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
    end

    add_index :course_instructors, [:course_id, :user_id], unique: true

    create_table :course_students do |t|
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
      t.jsonb :repository
    end

    add_index :course_students, [:course_id, :user_id], unique: true
  end
end
