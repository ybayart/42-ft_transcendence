class Game < ApplicationRecord
    belongs_to :player1, class_name: :User, optional: true
	belongs_to :player2, class_name: :User, optional: true
	belongs_to :winner, class_name: :User, optional: true
<<<<<<< HEAD
	belongs_to :tournament, optional: true
=======
	belongs_to :game_rules, class_name: :GameRule, optional: true
>>>>>>> 7b8069bc0080c196b6d727cf27f6113ec70df068
end
