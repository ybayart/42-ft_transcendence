class Tournament < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :games
	belongs_to :winner, class_name: :User, optional: true
	after_create_commit { CreateTournamentGamesJob.set(wait_until: self.start_time).perform_later(self) }

	validates :max_player, numericality: { only_interger: true , greater_than_or_equal_to: 2 }
	validates :points_award, numericality: { only_interger: true , greater_than_or_equal_to: 0 }

	validate :check_start_date, :on => :create

	def check_start_date
		errors.add(:start_time, "is in past") if self.start_time.past?
	end
end
