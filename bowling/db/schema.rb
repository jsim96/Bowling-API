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

ActiveRecord::Schema.define(version: 2019_07_25_032924) do

  create_table "frame_scores", force: :cascade do |t|
    t.integer "game_player_id"
    t.integer "frame_number"
    t.integer "roll_one_score"
    t.integer "roll_two_score"
    t.string "frame_result"
    t.integer "frame_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rolls_to_add"
    t.index ["game_player_id", "frame_number"], name: "index_frame_scores_on_game_player_id_and_frame_number", unique: true
    t.index ["game_player_id"], name: "index_frame_scores_on_game_player_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "current_frame"
    t.string "game_status"
    t.integer "cumulative_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "player_id"], name: "index_game_players_on_game_id_and_player_id", unique: true
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["player_id"], name: "index_game_players_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_players_on_name", unique: true
  end

end
