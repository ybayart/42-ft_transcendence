class Tournament < ApplicationRecord
	has_many :users
	has_many :games
	after_create_commit { CreateTournamentGamesJob.set(wait_until: self.start_time).perform_later(self) }
end
