class CreateMatchFromQueueJob < ApplicationJob
  queue_as :default

 	def perform(*args)
		@queue = Matchmaking.queue
		while @queue && @queue.length
			if @queue.length > 2
				$rand1 = rand(@queue.length)
				$rand2 = rand(@queue.length)
				while ($rand2 == $rand1)
					$rand2 = rand(@queue.length)
				end
				$player1 = @queue[$rand1]
				$player2 = @queue[$rand2]
				Matchmaking.removePlayerFromQueue($player1)
				Matchmaking.removePlayerFromQueue($player2)
				$game_id = createGame($player1, $player2)
				Matchmaking.redirectPlayer($player1, $game_id)
				Matchmaking.redirectPlayer($player2, $game_id)
			end
			sleep(5.0)
			@queue = Matchmaking.queue
		end
 	end

	def createGame(player1, player2)
		@game = Game.new
		@game.status = "waiting"
		@game.player1 = player1
		@game.player2 = player2
		@game.save
		@game.id
	end

end
