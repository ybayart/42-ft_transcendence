class CheckTournamentGameJob < ApplicationJob
	queue_as :default

	def perform(game)
		$gameLogic = GameLogic.create(game.id)
		if game.status == "waiting"
			if $gameLogic.player_ready[0] == false && $gameLogic.player_ready[1]
				game.winner = game.player2
			elsif $gameLogic.player_ready[1] == false && $gameLogic.player_ready[0]
				game.winner = game.player1
			else
				puts "$gameLogic: #{$gameLogic}"
				puts "player_ready[0]: #{$gameLogic.player_ready[0]}"
				puts "player_ready[1]: #{$gameLogic.player_ready[1]}"
				puts "player_nicknames[0]: #{$gameLogic.player_nicknames[0]}"
			end
			game.status = "finished"	
			game.save
			if game.mode == "war"
				@war_time = WarTimeLinkGame.find_by(game: game).war_time
				@war_time.increment!(:unanswered, 1)
				$gameLogic.attribute_points
			end
		end
	end
end
