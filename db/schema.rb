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

ActiveRecord::Schema.define(version: 20160228041534) do

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
    t.integer  "bk_moss_job_id"
    t.text     "moss_output"
    t.integer  "course_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "is_published"
    t.string   "test_repository"
    t.string   "skeleton_repository"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "courses_instructors", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "courses_instructors", ["course_id"], name: "index_courses_instructors_on_course_id", using: :btree
  add_index "courses_instructors", ["user_id"], name: "index_courses_instructors_on_user_id", using: :btree

  create_table "courses_students", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.string  "student_repository"
  end

  add_index "courses_students", ["course_id"], name: "index_courses_students_on_course_id", using: :btree
  add_index "courses_students", ["user_id"], name: "index_courses_students_on_user_id", using: :btree

  create_table "student_teams", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
  end

  add_index "student_teams", ["team_id"], name: "index_student_teams_on_team_id", using: :btree
  add_index "student_teams", ["user_id"], name: "index_student_teams_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "repository"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

end