class AddIndexToFrameScores < ActiveRecord::Migration[5.2]
  def change
    add_index :frame_scores, [:game_player_id, :frame_number], unique: true
  end
end
