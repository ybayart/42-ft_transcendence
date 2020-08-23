class Room < ApplicationRecord
	belongs_to :owner, class_name: "User", inverse_of: :rooms_owner, optional: true
	has_many :room_messages, dependent: :destroy, inverse_of: :room
	has_many :room_link_admins
	has_many :admins, :through => :room_link_admins, :source => :user
	has_many :room_link_members
	has_many :members, :through => :room_link_members, :source => :user
	has_many :bans, class_name: "RoomBan", foreign_key: "room_id", inverse_of: :room, dependent: :destroy
	has_many :mutes, class_name: "RoomMute", foreign_key: "room_id", inverse_of: :room, dependent: :destroy

	validates	:name, presence: true
	validates	:privacy,
					presence: true,
					inclusion: {
						in: %w(public private),
						message: "%{value} is not a valid privacy"}
	
	validate	:check_columns

	before_save		:check_modifications
	after_commit	:apply_modifications
	after_update	:notif_update

	def check_columns
		errors.add(:name, "must be unique") if Room.exists?(name: self.name) && self.id != Room.where(name: self.name).take.id
	end

	def check_modifications
		if !self.id || (Room.find(self.id).password != self.password && BCrypt::Password.new(Room.find(self.id).password) != self.password)
			self.password = BCrypt::Password.create(self.password)
		end
	end

	def apply_modifications
		ApplicationController.helpers.rebalance_rights(self)
	end

	def notif_update
		room = Room.find(self.id)
		output = {"type": "update", "content": {"name": self.name, "privacy": self.privacy, "id": self.id}}
		RoomChannel.broadcast_to room, output
	end
end
