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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121016142019) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "bio"
    t.string   "image_url"
    t.string   "web_url"
    t.string   "last_tid"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "panels", :id => false, :force => true do |t|
    t.integer  "id",                            :null => false
    t.integer  "room_id"
    t.integer  "width"
    t.integer  "height"
    t.integer  "bomb_flag",  :default => 0
    t.boolean  "is_open",    :default => false
    t.boolean  "is_bomb",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "panels", ["room_id"], :name => "index_panels_on_room_id"

  create_table "rooms", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.integer  "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
