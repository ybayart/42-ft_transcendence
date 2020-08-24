class GuildInvitMember < ApplicationRecord
	belongs_to :guild
	belongs_to :user
	belongs_to :by, class_name: 'User', inverse_of: :send_invites

	validates :state,
			presence: true,
			inclusion: {
				in: %w(waiting rejected accepted),
				message: "%{value} is not a valid state"}
end
