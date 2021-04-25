# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_25_195603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.bigint "winning_member_id", null: false
    t.bigint "losing_member_id", null: false
    t.boolean "draw"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["losing_member_id"], name: "index_matches_on_losing_member_id"
    t.index ["winning_member_id"], name: "index_matches_on_winning_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email_address"
    t.date "birthday"
    t.integer "games_played"
    t.integer "current_rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["current_rank"], name: "index_members_on_current_rank", unique: true
  end

  add_foreign_key "matches", "members", column: "losing_member_id", on_delete: :cascade
  add_foreign_key "matches", "members", column: "winning_member_id", on_delete: :cascade
end
