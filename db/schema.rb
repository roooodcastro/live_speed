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

ActiveRecord::Schema.define(version: 2019_01_13_174822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "game_players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "game_id"
    t.uuid "player_id"
    t.index ["game_id", "player_id"], name: "index_game_players_on_game_id_and_player_id"
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["player_id", "game_id"], name: "index_game_players_on_player_id_and_game_id"
    t.index ["player_id"], name: "index_game_players_on_player_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status"
    t.integer "num_rounds"
    t.uuid "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "own_name"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rounds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.json "data"
    t.uuid "winner_id"
    t.uuid "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["winner_id"], name: "index_rounds_on_winner_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "game_players", "games"
  add_foreign_key "game_players", "players"
  add_foreign_key "games", "players", column: "winner_id"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players", column: "winner_id"
end
