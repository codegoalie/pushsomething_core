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

ActiveRecord::Schema.define(version: 20140706212301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notifications", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "collapse_key"
    t.datetime "created_at"
    t.datetime "acknowledged_at"
    t.integer  "acknowledger_id"
    t.string   "source"
    t.string   "source_id"
    t.string   "remote_icon"
  end

  create_table "notifications_receivers", force: true do |t|
    t.integer "notification_id"
    t.integer "receiver_id"
  end

  create_table "receivers", force: true do |t|
    t.string   "uid",        null: false
    t.integer  "user_id",    null: false
    t.string   "gcm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
    t.string   "auth_token"
  end

  add_index "receivers", ["user_id", "uid"], name: "index_receivers_on_user_id_and_uid", unique: true, using: :btree

  create_table "services", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "token",      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                      default: "",    null: false
    t.string   "email",                     default: "",    null: false
    t.string   "encrypted_password",        default: "",    null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_uid"
    t.string   "facebook_token"
    t.integer  "facebook_token_expires_at"
    t.boolean  "admin",                     default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
