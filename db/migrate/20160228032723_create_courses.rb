class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :slug
      t.boolean :is_published
      t.string :test_repository
      t.string :skeleton_repository

      t.timestamps null: false
    end

    create_table :course_instructors, id: false do |t|
      t.references :course, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end

    add_index :course_instructors, [:course_id, :user_id], unique: true

    create_table :course_students, id: false do |t|
      t.references :course, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :student_repository
    end

    add_index :course_students, [:course_id, :user_id], unique: true
  end
end
