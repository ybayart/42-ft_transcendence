class CreateMatchFromQueueJob < ApplicationJob
  queue_as :default

 	def perform(*args)
		@queue = Matchmaking.queue
		while @queue && @queue.length > 0
			if @queue.length >= 2
				valplayer1 = nil
				valplayer2 = nil
				@queue[0..-2].each_with_index do |p1, i|
					valplayer1 = p1;
					valplayer2 = nil;
					@queue[i + 1..-1].each do |p2|
						if p2.rank == p1.rank + 1
							valplayer2 = p2;
							break
						elsif p2.rank == p1.rank
							valplayer2 = p2;
							break
						elsif p2.rank == p1.rank - 1
							valplayer2 = p2;
							break
						end
					end
				end
				if (valplayer1 && valplayer2)
					Matchmaking.removePlayerFromQueue(valplayer1)
					Matchmaking.removePlayerFromQueue(valplayer2)
					valgame_id = createGame(valplayer1, valplayer2)
					Matchmaking.redirectPlayer(valplayer1, valgame_id)
					Matchmaking.redirectPlayer(valplayer2, valgame_id)
					valplayer1 = nil
					valplayer2 = nil
				end
			end
			sleep(5.0)
			@queue = Matchmaking.queue
		end
 	end

	def createGame(player1, player2)
		@game = Game.create(player1: player1, player2: player2, status: "waiting", mode: "ranked")
		@game.id
	end

end
