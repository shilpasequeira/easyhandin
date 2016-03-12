# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160228042804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_published"
    t.datetime "deadline"
    t.datetime "grace_period"
    t.boolean  "is_team_mode"
    t.integer  "bk_moss_build_id"
    t.string   "bk_moss_job_id"
    t.text     "moss_output"
    t.integer  "course_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "assignments", ["course_id"], name: "index_assignments_on_course_id", using: :btree

  create_table "course_instructors", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "course_instructors", ["course_id", "user_id"], name: "index_course_instructors_on_course_id_and_user_id", unique: true, using: :btree
  add_index "course_instructors", ["course_id"], name: "index_course_instructors_on_course_id", using: :btree
  add_index "course_instructors", ["user_id"], name: "index_course_instructors_on_user_id", using: :btree

  create_table "course_students", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.string  "student_repository"
  end

  add_index "course_students", ["course_id", "user_id"], name: "index_course_students_on_course_id_and_user_id", unique: true, using: :btree
  add_index "course_students", ["course_id"], name: "index_course_students_on_course_id", using: :btree
  add_index "course_students", ["user_id"], name: "index_course_students_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_published"
    t.string   "test_repository"
    t.string   "skeleton_repository"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "student_teams", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
  end

  add_index "student_teams", ["team_id"], name: "index_student_teams_on_team_id", using: :btree
  add_index "student_teams", ["user_id", "team_id"], name: "index_student_teams_on_user_id_and_team_id", unique: true, using: :btree
  add_index "student_teams", ["user_id"], name: "index_student_teams_on_user_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.integer  "submitter_id"
    t.string   "submitter_type"
    t.integer  "grade"
    t.text     "feedback"
    t.integer  "test_result"
    t.text     "test_output"
    t.integer  "bk_test_build_id"
    t.string   "bk_test_job_id"
    t.string   "commit_sha"
    t.integer  "assignment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "submissions", ["assignment_id"], name: "index_submissions_on_assignment_id", using: :btree
  add_index "submissions", ["submitter_type", "submitter_id"], name: "index_submissions_on_submitter_type_and_submitter_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "repository"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["course_id"], name: "index_teams_on_course_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.integer  "role"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  add_foreign_key "assignments", "courses"
  add_foreign_key "course_instructors", "courses"
  add_foreign_key "course_instructors", "users"
  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "users"
  add_foreign_key "student_teams", "teams"
  add_foreign_key "student_teams", "users"
  add_foreign_key "submissions", "assignments"
  add_foreign_key "teams", "courses"
end
