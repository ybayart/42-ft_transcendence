class MatchmakingChannel < ApplicationCable::Channel
 
	def subscribed
		stream_from "matchmaking_#{current_user}"
	end

 	def unsubscribed
		unsubscribe_queue
 	end

	def register_to_queue
		Matchmaking.addPlayerToQueue(current_user)
	end

	def unsubscribe_queue
		Matchmaking.removePlayerFromQueue(current_user)
	end
end
