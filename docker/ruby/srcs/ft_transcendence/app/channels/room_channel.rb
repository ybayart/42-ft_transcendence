class RoomChannel < ApplicationCable::Channel
	def subscribed
		@room = Room.find(params[:room])
		unless current_user.receive_bans.where("room": @room).where("end_at > ?", DateTime.now.utc).exists?
			stream_for @room
			output = {"type": "join", "content": current_user}
			RoomChannel.broadcast_to @room, output
		end
	end
	def unsubscribed
		output = {"type": "left", "content": current_user}
		RoomChannel.broadcast_to @room, output
	end
end
