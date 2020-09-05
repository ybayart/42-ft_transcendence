class Tournament < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :games
	belongs_to :winner, class_name: :User, optional: true
	after_create_commit { CreateTournamentGamesJob.set(wait_until: self.start_time).perform_later(self) }
end
