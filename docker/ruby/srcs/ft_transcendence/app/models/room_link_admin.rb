class RoomLinkAdmin < ApplicationRecord
	belongs_to :room
	belongs_to :user

	before_save		:notif
	before_destroy	:notif
	after_commit	:check_modifications

	def	notif
		RoomChannel.broadcast_to self.room, {"type": "join", "content": self.user}
	end

	def check_modifications
		ApplicationController.helpers.rebalance_rights(self.room)
	end
end
