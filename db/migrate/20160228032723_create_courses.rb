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
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
    end

    create_table :course_students, id: false do |t|
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
      t.string :student_repository
    end
  end
end
