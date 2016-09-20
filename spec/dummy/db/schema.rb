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

ActiveRecord::Schema.define(version: 20160920172944) do

  create_table "addresses_addresses", force: :cascade do |t|
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
    t.index ["addressable_id"], name: "index_addresses_addresses_on_addressable_id"
    t.index ["city_id"], name: "index_addresses_addresses_on_city_id"
    t.index ["neighborhood_id"], name: "index_addresses_addresses_on_neighborhood_id"
  end

  create_table "addresses_cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["state_id"], name: "index_addresses_cities_on_state_id"
  end

  create_table "addresses_countries", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses_neighborhoods", force: :cascade do |t|
    t.integer  "city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["city_id"], name: "index_addresses_neighborhoods_on_city_id"
  end

  create_table "addresses_states", force: :cascade do |t|
    t.string   "name"
    t.string   "acronym"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["country_id"], name: "index_addresses_states_on_country_id"
  end

  create_table "addresses_zipcodes", force: :cascade do |t|
    t.string   "street"
    t.integer  "city_id"
    t.integer  "neighborhood_id"
    t.string   "number"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["city_id"], name: "index_addresses_zipcodes_on_city_id"
    t.index ["neighborhood_id"], name: "index_addresses_zipcodes_on_neighborhood_id"
  end

end
