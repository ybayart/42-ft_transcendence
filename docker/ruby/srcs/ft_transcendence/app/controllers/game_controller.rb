class GameController < ApplicationController

	def index
		ActionCable.server.broadcast('game', {content: "player connected"});
		@game = Game.find_by(status: "waiting");
		if (@game)
			@game.player2 = current_user
		else
			@game = Game.find_by(status: "empty")
			if (@game)
				@game.player1 = current_user
			end
		end
		if (@game.player1 && @game.player2)
			@game.status = "running"
			@game.update(player2: current_user, status: "running")
		else
			@game.status = "waiting"
			@game.update(player1: current_user, status: "waiting")
		end
		@game
	end
end
