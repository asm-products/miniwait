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

ActiveRecord::Schema.define(version: 20150208195706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string "description", limit: 80, null: false
  end

  create_table "companies", force: true do |t|
    t.integer "category_id",            null: false
    t.string  "name",        limit: 80, null: false
  end

  create_table "company_contacts", primary_key: "company_id", force: true do |t|
    t.integer "person_id",                  null: false
    t.boolean "is_primary", default: false
  end

  create_table "favorites", primary_key: "location_id", force: true do |t|
    t.integer "person_id", null: false
  end

  create_table "locations", force: true do |t|
    t.integer "company_id",                null: false
    t.string  "street1",        limit: 45, null: false
    t.string  "street2",        limit: 45
    t.string  "city",           limit: 45
    t.string  "state_province", limit: 45
    t.string  "postal_code",    limit: 10
    t.string  "country",        limit: 45
    t.string  "phone_number",   limit: 12
    t.string  "loc_name"
  end

  create_table "people", force: true do |t|
    t.string "username",             limit: 45,  null: false
    t.string "email_address",        limit: 90,  null: false
    t.string "first_name",           limit: 20,  null: false
    t.string "last_name",            limit: 30,  null: false
    t.string "street1",              limit: 45
    t.string "street2",              limit: 45
    t.string "city",                 limit: 45
    t.string "state_province",       limit: 45
    t.string "postal_code",          limit: 10
    t.string "country",              limit: 45
    t.string "phone_number",         limit: 12
    t.string "password_hash",        limit: 100, null: false
    t.string "password_salt"
    t.string "password_reset_token"
  end

  create_table "service_locations", force: true do |t|
    t.integer  "location_id",                      null: false
    t.integer  "service_id",                       null: false
    t.boolean  "is_available_here", default: true, null: false
    t.integer  "wait_time",                        null: false
    t.datetime "wait_time_updated"
  end

  create_table "service_watches", primary_key: "service_location_id", force: true do |t|
    t.integer "person_id", null: false
  end

  create_table "services", force: true do |t|
    t.integer "company_id",             null: false
    t.string  "description", limit: 45, null: false
    t.string  "is_primary",  limit: 1
  end

end
