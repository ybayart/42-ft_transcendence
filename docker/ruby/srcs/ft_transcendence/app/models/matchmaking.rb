class Matchmaking
	include ActiveModel::Model

	def self.addPlayerToQueue(id)
		@queue ||= []
		if !@queue.include?(id)
			@queue.push(id)
			if @queue.length == 1
				CreateMatchFromQueueJob.perform_later()
			end
		end
	end

	def self.removePlayerFromQueue(id)
		if @queue && @queue.include?(id)
			@queue.delete(id)
		end
	end

	def self.redirectPlayer(id, game_id)
		ActionCable.server.broadcast("matchmaking_#{id}", {
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
