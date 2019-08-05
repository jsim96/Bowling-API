class AddColumnToFrameScores < ActiveRecord::Migration[5.2]
  def change
    add_column :frame_scores, :rolls_to_add, :integer
  end
end
