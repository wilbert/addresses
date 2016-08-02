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

ActiveRecord::Schema.define(version: 20160802214929) do

  create_table "addresses_addresses", force: true do |t|
    t.string   "street"
    t.string   "number"
    t.string   "complement"
    t.integer  "city_id"
    t.integer  "neighborhood_id"
    t.string   "zipcode"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses_addresses", ["city_id"], name: "index_addresses_addresses_on_city_id"
  add_index "addresses_addresses", ["neighborhood_id"], name: "index_addresses_addresses_on_neighborhood_id"

  create_table "addresses_cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relevance",  default: 0
  end

  add_index "addresses_cities", ["state_id"], name: "index_addresses_cities_on_state_id"

  create_table "addresses_countries", force: true do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses_neighborhoods", force: true do |t|
    t.integer  "city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses_neighborhoods", ["city_id"], name: "index_addresses_neighborhoods_on_city_id"

  create_table "addresses_states", force: true do |t|
    t.string   "name"
    t.string   "acronym"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relevance",  default: 0
  end

  add_index "addresses_states", ["country_id"], name: "index_addresses_states_on_country_id"

end
