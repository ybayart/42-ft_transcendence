class RoomChannel < ApplicationCable::Channel
	def subscribed
		room = Room.find params[:room]
		stream_for room unless current_user.receive_bans.where("room": room).where("end_at > ?", DateTime.now.utc).exists?
	end
end
