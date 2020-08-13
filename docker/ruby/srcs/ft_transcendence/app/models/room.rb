class Room < ApplicationRecord
	has_many :room_messages, dependent: :destroy, inverse_of: :room
	has_many :room_link_members
	has_many :members, :through => :room_link_members, :source => :user
	has_many :bans, class_name: "RoomBan", foreign_key: "room_id", inverse_of: :room
	has_many :mutes, class_name: "RoomMute", foreign_key: "room_id", inverse_of: :room

	validates	:name, presence: true
	validates	:privacy,
					presence: true,
					inclusion: {
						in: %w(public private),
						message: "%{value} is not a valid privacy"}
end
