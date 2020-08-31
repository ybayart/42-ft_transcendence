class CreateMatchFromQueueJob < ApplicationJob
  queue_as :default

 	def perform(*args)
		@queue = Matchmaking.queue
		while @queue && @queue.length > 0
			if @queue.length >= 2
				@queue[0..-2].each_with_index do |p1, i|
					$player1 = p1;
					$player2 = nil;
					@queue[i..-1].each_with_index do |p2, j|
						if p2.rank == p1.rank + 1
							$player2 = p2;
							break
						elsif p2.rank == p1.rank
							$player2 = p2;
							break
						elsif p2.rank == p1.rank - 1
							$player2 = p2;
							break
						end
					end
				end
				if ($player1 && $player2)						
					Matchmaking.removePlayerFromQueue($player1)
					Matchmaking.removePlayerFromQueue($player2)
					$game_id = createGame($player1, $player2)
					Matchmaking.redirectPlayer($player1, $game_id)
					Matchmaking.redirectPlayer($player2, $game_id)
					$player1 = nil
					$player2 = nil
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
