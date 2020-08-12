class RoomMute < ApplicationRecord
	belongs_to	:user, inverse_of: :receive_mutes
	belongs_to	:by, class_name: 'User', inverse_of: :send_mutes
	belongs_to	:room
end
