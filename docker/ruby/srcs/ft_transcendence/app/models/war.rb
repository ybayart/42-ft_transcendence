class War < ApplicationRecord
	belongs_to :guild1, class_name: :Guild, required: true
	belongs_to :guild2, class_name: :Guild, required: true
	belongs_to :winner, class_name: :Guild, required: false
	has_many :war_times, dependent: :destroy, inverse_of: :war

	validate :check_dates

	def check_dates
		errors.add(:start_at, "is in past") if self.start_at.past?
		errors.add(:end_at, "is before start date") if self.end_at < self.start_at
	end
end
