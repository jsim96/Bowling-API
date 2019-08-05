class RemoveColumnFromFrameScores < ActiveRecord::Migration[5.2]
  def change
    remove_column :frame_scores, :roll_to_add
  end
end
