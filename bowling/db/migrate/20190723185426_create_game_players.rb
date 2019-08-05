class CreateGamePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players do |t|
      t.references :game, foreign_key: true
      t.references :player, foreign_key: true
      t.integer :current_frame
      t.string :game_status
      t.integer :cumulative_score

      t.timestamps
    end
  end
end
