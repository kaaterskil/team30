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

ActiveRecord::Schema.define(version: 20140709231643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: true do |t|
    t.integer  "user_id",        null: false
    t.date     "entry_date",     null: false
    t.integer  "total_calories"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "exercises", ["entry_date"], name: "index_exercises_on_entry_date", using: :btree
  add_index "exercises", ["team_id"], name: "index_exercises_on_team_id", using: :btree
  add_index "exercises", ["user_id"], name: "index_exercises_on_user_id", using: :btree

  create_table "ingredients", force: true do |t|
    t.integer  "user_id",          null: false
    t.integer  "team_id"
    t.integer  "meal_id",          null: false
    t.date     "meal_date"
    t.string   "brand_name"
    t.string   "item_name"
    t.string   "brand_id"
    t.string   "item_id"
    t.integer  "item_type"
    t.text     "item_description"
    t.integer  "calories"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients", ["meal_id"], name: "index_ingredients_on_meal_id", using: :btree
  add_index "ingredients", ["team_id"], name: "index_ingredients_on_team_id", using: :btree
  add_index "ingredients", ["user_id"], name: "index_ingredients_on_user_id", using: :btree

  create_table "meals", force: true do |t|
    t.integer  "user_id",        null: false
    t.string   "meal_type",      null: false
    t.date     "meal_date",      null: false
    t.integer  "total_calories"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "meals", ["meal_date"], name: "index_meals_on_meal_date", using: :btree
  add_index "meals", ["team_id"], name: "index_meals_on_team_id", using: :btree
  add_index "meals", ["user_id"], name: "index_meals_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id",                    null: false
    t.integer  "recipient_id",                 null: false
    t.integer  "team_id"
    t.integer  "thread_id"
    t.text     "content"
    t.boolean  "is_private",   default: false, null: false
    t.boolean  "is_unread",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                      null: false
    t.boolean  "sent",         default: true
  end

  add_index "messages", ["created_at"], name: "index_messages_on_created_at", using: :btree
  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  add_index "messages", ["sent"], name: "index_messages_on_sent", using: :btree
  add_index "messages", ["team_id"], name: "index_messages_on_team_id", using: :btree
  add_index "messages", ["thread_id"], name: "index_messages_on_thread_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "rosters", force: true do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "team_id",                                 null: false
    t.integer  "starting_weight"
    t.string   "activity_level"
    t.integer  "bmr"
    t.integer  "tdee"
    t.integer  "target_weight"
    t.integer  "target_calories_per_day"
    t.boolean  "is_record_locked",        default: false, null: false
    t.integer  "forecast_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rosters", ["user_id", "team_id"], name: "index_rosters_on_user_id_and_team_id", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.date     "starting_on"
    t.date     "ending_on"
    t.boolean  "is_target_weight_locked", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "leader_id"
    t.boolean  "is_active",               default: true,  null: false
  end

  add_index "teams", ["is_active"], name: "index_teams_on_is_active", using: :btree
  add_index "teams", ["leader_id"], name: "index_teams_on_leader_id", using: :btree
  add_index "teams", ["parent_id"], name: "index_teams_on_parent_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
    t.integer  "height"
    t.date     "birth_date"
    t.string   "known_by"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weigh_ins", force: true do |t|
    t.integer  "user_id",         null: false
    t.date     "entry_date",      null: false
    t.integer  "measured_weight", null: false
    t.integer  "total_calories"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "weigh_ins", ["entry_date"], name: "index_weigh_ins_on_entry_date", using: :btree
  add_index "weigh_ins", ["team_id"], name: "index_weigh_ins_on_team_id", using: :btree
  add_index "weigh_ins", ["user_id"], name: "index_weigh_ins_on_user_id", using: :btree

end
