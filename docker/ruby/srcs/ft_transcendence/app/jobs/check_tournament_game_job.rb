class CheckTournamentGameJob < ApplicationJob
	queue_as :default

	def perform(id)
		@gameLogic = GameLogic.search(id)
		if @gameLogic
			@game = @gameLogic.game
		else
			@gameLogic = GameLogic.create(id)
			@game = Game.find(id)
		end
		if @game.status == "waiting"
			if @gameLogic.player_ready[0] == false && @gameLogic.player_ready[1]
				@game.winner = @game.player2
			elsif @gameLogic.player_ready[1] == false && @gameLogic.player_ready[0]
				@game.winner = @game.player1
			end
			@game.status = "finished"	
			@game.save
			if @game.mode == "war"
				@war_time = WarTimeLinkGame.find_by(game: @game).war_time
				@war_time.increment!(:unanswered, 1)
				@gameLogic.attribute_points
			end
		end
	end
end
