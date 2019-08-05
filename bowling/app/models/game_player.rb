class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :player
  # validation
  validates :game, uniqueness: {scope: :player}
end
