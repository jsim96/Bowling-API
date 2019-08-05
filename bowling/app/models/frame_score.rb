class FrameScore < ApplicationRecord
  # validation
  belongs_to :game_player
  validates :game_player, uniqueness: {scope: :frame_number}
end
