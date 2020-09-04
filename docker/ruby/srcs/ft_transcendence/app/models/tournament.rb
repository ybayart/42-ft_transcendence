class Tournament < ApplicationRecord
	has_many :users
	after_create_commit { CreateTournamentGamesJob.set(wait_until: self.start_time).perform_later(self) }
end
