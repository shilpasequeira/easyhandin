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

ActiveRecord::Schema.define(version: 20160312231353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string   "name"
    t.string   "branch_name"
    t.boolean  "is_published",        default: false
    t.datetime "deadline"
    t.datetime "grace_period"
    t.boolean  "is_team_mode",        default: false
    t.integer  "bk_moss_build_id"
    t.string   "bk_moss_job_id"
    t.integer  "moss_result"
    t.text     "moss_output"
    t.integer  "language"
    t.jsonb    "submission_repo_sha"
    t.integer  "course_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "assignments", ["course_id"], name: "index_assignments_on_course_id", using: :btree

  create_table "course_instructors", force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "course_instructors", ["course_id", "user_id"], name: "index_course_instructors_on_course_id_and_user_id", unique: true, using: :btree
  add_index "course_instructors", ["course_id"], name: "index_course_instructors_on_course_id", using: :btree
  add_index "course_instructors", ["user_id"], name: "index_course_instructors_on_user_id", using: :btree

  create_table "course_students", force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.jsonb   "repository"
  end

  add_index "course_students", ["course_id", "user_id"], name: "index_course_students_on_course_id_and_user_id", unique: true, using: :btree
  add_index "course_students", ["course_id"], name: "index_course_students_on_course_id", using: :btree
  add_index "course_students", ["user_id"], name: "index_course_students_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "org_name"
    t.jsonb    "test_repository"
    t.jsonb    "skeleton_repository"
    t.boolean  "is_published",        default: false
    t.integer  "easyhandin_team_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "invites", force: :cascade do |t|
    t.string   "name"
    t.string   "user_role"
    t.string   "email"
    t.string   "university_id"
    t.boolean  "is_accepted",   default: false
    t.string   "token"
    t.integer  "course_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "invites", ["course_id", "sender_id", "email"], name: "index_invites_on_course_id_and_sender_id_and_email", unique: true, using: :btree
  add_index "invites", ["course_id"], name: "index_invites_on_course_id", using: :btree
  add_index "invites", ["recipient_id"], name: "index_invites_on_recipient_id", using: :btree
  add_index "invites", ["sender_id"], name: "index_invites_on_sender_id", using: :btree

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
    t.jsonb    "repository"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["course_id"], name: "index_teams_on_course_id", using: :btree

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
  end

  add_index "teams_users", ["team_id"], name: "index_teams_users_on_team_id", using: :btree
  add_index "teams_users", ["user_id", "team_id"], name: "index_teams_users_on_user_id_and_team_id", unique: true, using: :btree
  add_index "teams_users", ["user_id"], name: "index_teams_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "university_id"
    t.integer  "role"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

end
