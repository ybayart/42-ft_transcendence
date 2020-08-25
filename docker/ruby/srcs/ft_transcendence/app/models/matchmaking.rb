class Matchmaking
	include ActiveModel::Model

	def self.addPlayerToQueue(user)
		@queue ||= []
		if !@queue.include?(user)
			@queue.push(user)
			if @queue.length == 1
				CreateMatchFromQueueJob.perform_later()
			end
		end
	end

	def self.removePlayerFromQueue(user)
		if @queue && @queue.include?(user)
			@queue.delete(user)
		end
	end

	def self.redirectPlayer(user, game_id)
		ActionCable.server.broadcast("matchmaking_#{user}", {
			game:
			{
				id: game_id
			}
		})
	end

	def self.queue
		@queue
	end

end
