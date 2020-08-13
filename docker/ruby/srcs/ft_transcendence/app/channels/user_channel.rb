class UserChannel < ApplicationCable::Channel
	def subscribed
		# stream_from "some_channel"
		stream_for current_user
		current_user.increment(:count_co).save
		check_state
	end

	def unsubscribed
		current_user.decrement(:count_co).save
		check_state
		# Any cleanup needed when channel is unsubscribed
	end

	private
		def check_state
			current_user.update(state: (current_user.count_co > 0 ? "online" : "offline"))
		end
end
