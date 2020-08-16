class Game < ApplicationRecord
	belongs_to :player1, class_name: :user, optional: true
	belongs_to :player2, class_name: :user, optional: true
end
