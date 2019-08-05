class Player < ApplicationRecord
    # validation
    validates :name, uniqueness: true
end
