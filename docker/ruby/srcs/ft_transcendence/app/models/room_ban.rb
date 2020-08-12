class RoomBan < ApplicationRecord
	belongs_to	:user, inverse_of: :receive_bans
	belongs_to	:by, class_name: 'User', inverse_of: :send_bans
	belongs_to	:room
end
