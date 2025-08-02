# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_02_143316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "semester_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "student_id", null: false
    t.bigint "teacher_id", null: false
    t.date "attendance_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["semester_id", "subject_id", "student_id", "teacher_id", "attendance_date"], name: "idx_on_semester_id_subject_id_student_id_teacher_id_271ec6d6dc", unique: true
    t.index ["semester_id"], name: "index_attendances_on_semester_id"
    t.index ["student_id"], name: "index_attendances_on_student_id"
    t.index ["subject_id"], name: "index_attendances_on_subject_id"
    t.index ["teacher_id"], name: "index_attendances_on_teacher_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "code", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semesters", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", limit: 255, null: false
    t.bigint "department_id", null: false
    t.bigint "semester_id", null: false
    t.string "roll_number", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_students_on_department_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
    t.index ["semester_id"], name: "index_students_on_semester_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "code", limit: 3, null: false
    t.bigint "semester_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "department_id", null: false
    t.index ["semester_id"], name: "index_subjects_on_semester_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 2, default: 0, null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "semesters", on_delete: :nullify
  add_foreign_key "attendances", "students", on_delete: :nullify
  add_foreign_key "attendances", "subjects", on_delete: :nullify
  add_foreign_key "attendances", "teachers", on_delete: :nullify
  add_foreign_key "students", "departments", on_delete: :cascade
  add_foreign_key "students", "semesters", on_delete: :cascade
  add_foreign_key "subjects", "departments", on_delete: :cascade
  add_foreign_key "subjects", "semesters", on_delete: :cascade
end
