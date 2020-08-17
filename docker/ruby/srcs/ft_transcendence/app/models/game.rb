class Game < ApplicationRecord
    belongs_to :player1, class_name: :User, optional: true
	belongs_to :player2, class_name: :User, optional: true
	belongs_to :winner, class_name: :User, optional: true
end
