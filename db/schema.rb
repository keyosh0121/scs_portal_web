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

ActiveRecord::Schema.define(version: 20171112091252) do

  create_table "bands", force: :cascade do |t|
    t.string "name"
    t.string "pa"
    t.string "master"
    t.integer "year"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "members"
    t.boolean "registration", default: false, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "sender"
    t.string "atevent"
    t.string "atcontent"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.text "contents"
    t.boolean "commentable"
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
  end

  create_table "mics", force: :cascade do |t|
    t.string "band"
    t.string "pa"
    t.string "paattendance"
    t.string "sender"
    t.date "date"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
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

  create_table "room_usages", force: :cascade do |t|
    t.string "band"
    t.string "sender"
    t.date "date"
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "period"
    t.string "room"
  end

  create_table "temporal_bands", force: :cascade do |t|
    t.string "name"
    t.text "members"
    t.string "event"
    t.string "music"
    t.time "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
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
  end

end
