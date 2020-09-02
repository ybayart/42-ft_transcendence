class RoomMute < ApplicationRecord
	belongs_to	:user, inverse_of: :receive_mutes
	belongs_to	:by, class_name: 'User', inverse_of: :send_mutes
	belongs_to	:room

	validates	:end_at, presence: true

	validate	:not_in_past

	def not_in_past
		errors.add(:nickname, "In the past") if self.end_at.past?
	end
end
