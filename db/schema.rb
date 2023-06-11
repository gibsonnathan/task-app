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

ActiveRecord::Schema[7.0].define(version: 2023_06_10_033533) do
  create_table "bids", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount"
    t.string "unit"
    t.boolean "deleted", default: false
    t.index ["task_id"], name: "index_bids_on_task_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.string "message", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_notifications_on_task_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.float "lat", null: false
    t.float "long", null: false
    t.string "title", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "pfp_link"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "watched_tasks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bids", "tasks"
  add_foreign_key "bids", "users"
  add_foreign_key "notifications", "tasks"
  add_foreign_key "notifications", "users"
  add_foreign_key "tasks", "users"
end
