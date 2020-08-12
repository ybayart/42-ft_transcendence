class Room < ApplicationRecord
	has_many :room_messages, dependent: :destroy, inverse_of: :room
	has_many :bans, inverse_of: :room
	has_many :mutess, inverse_of: :room
end
