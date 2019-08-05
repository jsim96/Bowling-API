class AddIndexToGamePlayers < ActiveRecord::Migration[5.2]
  def change
    add_index :game_players, [:game_id, :player_id], unique: true
  end
end
