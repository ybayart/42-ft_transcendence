class CheckTournamentGameJob < ApplicationJob
	queue_as :default

	def perform(tournament, game)
		$gameLogic = GameLogic.create(game.id)
		if game.status == "waiting"
			game.status = "finished"	
			if $gameLogic.player_ready[0] == false && $gameLogic.player_ready[1]
				game.winner = game.player2
			elsif $gameLogic.player_ready[1] == false && $gameLogic.player_ready[0]
				game.winner = game.player1
			end
			game.save
			if game.mode == "war"
				@war_time = WarTimeLinkGame.find_by(game: game).war_time
				@war_time.increment!(:unanswered, 1)
				$gameLogic.attributes_points
			end
		end
	end
end
