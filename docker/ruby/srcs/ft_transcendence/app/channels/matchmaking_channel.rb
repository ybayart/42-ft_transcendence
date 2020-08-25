class MatchmakingChannel < ApplicationCable::Channel
 
	def subscribed
		stream_from "matchmaking_#{current_user}"
		Matchmaking.addPlayerToQueue(current_user)
	end

 	def unsubscribed
		Matchmaking.removePlayerFromQueue(current_user)
 	end

end
