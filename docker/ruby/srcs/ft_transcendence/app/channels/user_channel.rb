class UserChannel < ApplicationCable::Channel
	def subscribed
		# stream_from "some_channel"
		stream_for current_user
		current_user.update(state: "online")
	end

	def unsubscribed
		current_user.update(state: "offline")
		# Any cleanup needed when channel is unsubscribed
	end
end
