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

ActiveRecord::Schema[7.0].define(version: 2026_02_26_155306) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "multiplayer_games", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.text "player1_board"
    t.text "player2_board"
    t.text "declared_numbers"
    t.string "current_turn"
    t.string "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_multiplayer_games_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "code", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "player1_token"
    t.string "player2_token"
    t.index ["code"], name: "index_rooms_on_code", unique: true
  end

  add_foreign_key "multiplayer_games", "rooms"
end
