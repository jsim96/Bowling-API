class CreateFrameScores < ActiveRecord::Migration[5.2]
  def change
    create_table :frame_scores do |t|
      t.references :game_player, foreign_key: true
      t.integer :frame_number
      t.integer :roll_one_score
      t.integer :roll_two_score
      t.string :frame_result
      t.integer :frame_score

      t.timestamps
    end
  end
end
