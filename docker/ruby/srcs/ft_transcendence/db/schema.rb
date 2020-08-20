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

ActiveRecord::Schema.define(version: 2020_08_18_164417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "friendships", id: false, force: :cascade do |t|
    t.bigint "friend_a_id"
    t.bigint "friend_b_id"
    t.index ["friend_a_id"], name: "index_friendships_on_friend_a_id"
    t.index ["friend_b_id"], name: "index_friendships_on_friend_b_id"
  end

  create_table "room_bans", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "by_id"
    t.bigint "room_id"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["by_id"], name: "index_room_bans_on_by_id"
    t.index ["room_id"], name: "index_room_bans_on_room_id"
    t.index ["user_id"], name: "index_room_bans_on_user_id"
  end

  create_table "room_link_admins", id: false, force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.index ["room_id"], name: "index_room_link_admins_on_room_id"
    t.index ["user_id"], name: "index_room_link_admins_on_user_id"
  end

  create_table "room_link_members", id: false, force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.index ["room_id"], name: "index_room_link_members_on_room_id"
    t.index ["user_id"], name: "index_room_link_members_on_user_id"
  end

  create_table "room_messages", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_room_messages_on_room_id"
    t.index ["user_id"], name: "index_room_messages_on_user_id"
  end

  create_table "room_mutes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "room_id"
    t.bigint "by_id"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["by_id"], name: "index_room_mutes_on_by_id"
    t.index ["room_id"], name: "index_room_mutes_on_room_id"
    t.index ["user_id"], name: "index_room_mutes_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "privacy"
    t.string "password"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_rooms_on_name", unique: true
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "login"
    t.string "provider"
    t.string "uid"
    t.string "nickname"
    t.string "state", default: "offline"
    t.integer "count_co", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "friendships", "users", column: "friend_a_id"
  add_foreign_key "friendships", "users", column: "friend_b_id"
  add_foreign_key "room_bans", "users", column: "by_id"
  add_foreign_key "room_messages", "rooms"
  add_foreign_key "room_messages", "users"
  add_foreign_key "room_mutes", "users", column: "by_id"
end