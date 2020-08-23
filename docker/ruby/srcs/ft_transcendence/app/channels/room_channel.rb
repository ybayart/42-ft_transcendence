class RoomChannel < ApplicationCable::Channel
	def subscribed
		@room = Room.find(params[:room])
		pass = BCrypt::Password.new(@room.password)
		unless current_user.receive_bans.where("room": @room).where("end_at > ?", DateTime.now.utc).exists? and (pass == "" or pass == session[:room_passwords][@room.id.to_s])
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
