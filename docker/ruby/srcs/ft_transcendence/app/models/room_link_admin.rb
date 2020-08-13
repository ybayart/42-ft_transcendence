class RoomLinkAdmin < ApplicationRecord
	belongs_to :room
	belongs_to :user

	after_destroy :exclude_member
	after_commit :check_modifications

	def check_modifications
		ApplicationController.helpers.rebalance_rights(self.room)
	end

	def exclude_member
		puts "----------------------"
		self.room.members.delete(self.user)
	end
end
