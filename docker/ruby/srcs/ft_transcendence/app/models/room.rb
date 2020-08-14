class Room < ApplicationRecord
	belongs_to :owner, class_name: "User", inverse_of: :rooms_owner, optional: true
	has_many :room_messages, dependent: :destroy, inverse_of: :room
	has_many :room_link_admins
	has_many :admins, :through => :room_link_admins, :source => :user
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
	
	validate	:check_columns

	after_commit :check_modifications

	def check_columns
		errors.add(:name, "must be unique") if Room.exists?(name: self.name) && self.id != Room.where(name: self.name).take.id
	end

	def check_modifications
		ApplicationController.helpers.rebalance_rights(self)
	end
end
