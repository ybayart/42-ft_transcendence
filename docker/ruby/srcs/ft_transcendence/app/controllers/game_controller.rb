class GameController < ApplicationController

	def index
		ActionCable.server.broadcast('game', {content: "player connected"});
		@game = Game.find_by(status: "running", player1: current_user);
		if (!@game)
			@game = Game.find_by(status: "running", player2: current_user);
			if (!@game)
				@game = Game.find_by(status: "waiting");
				if (@game)
					@game.player2 = current_user
					@game.status = "running"
					@game.update(player2: current_user, status: "running")
				else
					@game = Game.find_by(status: "empty")
					if (@game)
						@game.player1 = current_user
						@game.status = "waiting"
						@game.update(player1: current_user, status: "waiting")
					end
					if (!@game)
						@game = Game.new()
						@game.status = "waiting"
						@game.player1 = current_user
						@game.save
					end
				end
			end
		end
		@game
	end
end
