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

ActiveRecord::Schema.define(version: 20180214065157) do

  create_table "band_members", force: :cascade do |t|
    t.integer "band_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bands", force: :cascade do |t|
    t.string "name"
    t.string "pa"
    t.string "master"
    t.integer "year"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "registration", default: false, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "sender"
    t.string "atevent"
    t.string "atcontent"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "content_id"
    t.integer "reply_to"
    t.integer "sender_id"
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.text "contents"
    t.boolean "commentable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "regular_band_id"
    t.integer "temporal_band_id"
    t.integer "entry_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
    t.string "musics"
    t.string "times"
  end

  create_table "event_contents", force: :cascade do |t|
    t.string "name"
    t.string "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.date "date"
    t.time "start_time"
    t.boolean "able_to_comment", default: false, null: false
    t.boolean "entry_required", default: false, null: false
    t.string "category"
    t.text "contents"
    t.integer "event_type"
  end

  create_table "mic_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room"
    t.date "date"
    t.string "time"
    t.integer "reservation_type_num"
  end

  create_table "mics", force: :cascade do |t|
    t.string "band"
    t.string "pa"
    t.string "paattendance"
    t.string "sender"
    t.date "date"
    t.string "time"
    t.string "approval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.integer "band_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.time "time"
    t.string "content"
  end

  create_table "performances", force: :cascade do |t|
    t.string "at"
    t.text "bands"
    t.date "date"
    t.boolean "commentable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reply_to_comments", force: :cascade do |t|
    t.integer "type"
    t.integer "comment_id"
    t.integer "sender_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_usages", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "period"
    t.string "room"
    t.integer "band_id"
    t.integer "user_id"
  end

  create_table "temporal_band_members", force: :cascade do |t|
    t.integer "band_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temporal_bands", force: :cascade do |t|
    t.string "name"
    t.string "event"
    t.string "music"
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "tel"
    t.string "univ"
    t.integer "year"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authority"
    t.boolean "approval", default: false
    t.string "remember_digest"
    t.string "passward_digest"
  end

end
