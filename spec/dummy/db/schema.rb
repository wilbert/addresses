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

ActiveRecord::Schema.define(version: 2019_10_11_003840) do

  create_table "addresses_addresses", force: :cascade do |t|
    t.string "number"
    t.string "complement"
    t.integer "addressable_id"
    t.string "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "zipcode_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_addressable"
    t.index ["addressable_id"], name: "index_addresses_addresses_on_addressable_id"
    t.index ["latitude"], name: "index_addresses_addresses_on_latitude"
    t.index ["longitude"], name: "index_addresses_addresses_on_longitude"
    t.index ["zipcode_id"], name: "index_addresses_addresses_on_zipcode_id"
  end

  create_table "addresses_cities", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.index ["latitude"], name: "index_addresses_cities_on_latitude"
    t.index ["longitude"], name: "index_addresses_cities_on_longitude"
    t.index ["name", "state_id"], name: "index_addresses_cities_on_name_and_state_id"
    t.index ["name"], name: "index_addresses_cities_on_name"
    t.index ["state_id"], name: "index_addresses_cities_on_state_id"
  end

  create_table "addresses_countries", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.index ["acronym"], name: "index_addresses_countries_on_acronym"
    t.index ["latitude"], name: "index_addresses_countries_on_latitude"
    t.index ["longitude"], name: "index_addresses_countries_on_longitude"
    t.index ["name"], name: "index_addresses_countries_on_name"
  end

  create_table "addresses_neighborhoods", force: :cascade do |t|
    t.integer "city_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.index ["city_id"], name: "index_addresses_neighborhoods_on_city_id"
    t.index ["latitude"], name: "index_addresses_neighborhoods_on_latitude"
    t.index ["longitude"], name: "index_addresses_neighborhoods_on_longitude"
    t.index ["name", "city_id"], name: "index_addresses_neighborhoods_on_name_and_city_id"
    t.index ["name"], name: "index_addresses_neighborhoods_on_name"
  end

  create_table "addresses_regions", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.float "latitude"
    t.float "longitude"
    t.integer "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"name\", \"contry_id\"", name: "index_addresses_regions_on_name_and_contry_id"
    t.index ["country_id"], name: "index_addresses_regions_on_country_id"
    t.index ["name"], name: "index_addresses_regions_on_name"
  end

  create_table "addresses_states", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "capital_id"
    t.integer "region_id"
    t.float "latitude"
    t.float "longitude"
    t.index ["country_id"], name: "index_addresses_states_on_country_id"
    t.index ["latitude"], name: "index_addresses_states_on_latitude"
    t.index ["longitude"], name: "index_addresses_states_on_longitude"
    t.index ["name", "country_id"], name: "index_addresses_states_on_name_and_country_id"
    t.index ["name"], name: "index_addresses_states_on_name"
    t.index ["region_id"], name: "index_addresses_states_on_region_id"
  end

  create_table "addresses_zipcodes", force: :cascade do |t|
    t.string "street"
    t.integer "city_id"
    t.integer "neighborhood_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["city_id"], name: "index_addresses_zipcodes_on_city_id"
    t.index ["latitude"], name: "index_addresses_zipcodes_on_latitude"
    t.index ["longitude"], name: "index_addresses_zipcodes_on_longitude"
    t.index ["neighborhood_id"], name: "index_addresses_zipcodes_on_neighborhood_id"
    t.index ["number"], name: "index_addresses_zipcodes_on_number"
  end

end
