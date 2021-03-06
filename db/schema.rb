# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_08_011248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_tracks", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.bigint "user_project_id", null: false
    t.index ["user_project_id"], name: "index_attendance_tracks_on_user_project_id"
  end

  create_table "authorities", force: :cascade do |t|
    t.integer "authority", default: 0, null: false
    t.bigint "user_company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_company_id"], name: "index_authorities_on_user_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "zipcode"
    t.string "phone_number"
    t.string "email"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "user_project_id", null: false
    t.integer "wage"
    t.string "wage_per"
    t.integer "hours_per_month"
    t.date "start_at", null: false
    t.date "end_at"
    t.boolean "daily_reports_required", default: false, null: false
    t.string "role", null: false
    t.boolean "under_contract", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_project_id"], name: "index_contracts_on_user_project_id"
  end

  create_table "daily_reports", force: :cascade do |t|
    t.bigint "user_project_id", null: false
    t.date "date", null: false
    t.string "contents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_project_id"], name: "index_daily_reports_on_user_project_id"
  end

  create_table "notices", force: :cascade do |t|
    t.bigint "user_project_id", null: false
    t.string "contents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_project_id"], name: "index_notices_on_user_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "billing_destination_email"
    t.string "billing_destination_manager"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.integer "budget"
    t.string "schedule"
    t.index ["company_id"], name: "index_projects_on_company_id"
  end

  create_table "user_companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_user_companies_on_company_id"
    t.index ["user_id"], name: "index_user_companies_on_user_id"
  end

  create_table "user_projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendance_tracks", "user_projects"
  add_foreign_key "authorities", "user_companies"
  add_foreign_key "contracts", "user_projects"
  add_foreign_key "daily_reports", "user_projects"
  add_foreign_key "notices", "user_projects"
  add_foreign_key "projects", "companies"
  add_foreign_key "user_companies", "companies"
  add_foreign_key "user_companies", "users"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
end
