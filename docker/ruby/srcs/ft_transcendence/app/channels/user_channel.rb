class UserChannel < ApplicationCable::Channel
	def subscribed
		stream_for current_user
		stream_from "user_channel"
		online()
	end

	def unsubscribed
		offline()
	end

	def online()
		unless current_user[:state] == "online"
			current_user.update(state: "online")
			output = {"type": "online", "content": current_user}
			ActionCable.server.broadcast("user_channel", output)
		end
	end

	def offline()
		unless current_user[:state] == "offline"
			current_user.update(state: "offline")
			output = {"type": "offline", "content": current_user}
			ActionCable.server.broadcast("user_channel", output)
		end
	end
end
