class GameChannel < ApplicationCable::Channel

	def subscribed
		stream_from "game_#{params[:game]}"
		@gameLogic = GameLogic.create(params[:game])
		@game = @gameLogic.game
		if current_user == @game.player1 && current_user != @game.player2
			UpdateGameStateJob.perform_later(params[:game])
		end
		if current_user != @game.player1 && current_user != @game.player2
			@gameLogic.addSpec
		end
		ActionCable.server.broadcast("game_#{@game.id}", {
			config:
			{
				canvas:
				{
					width: @gameLogic.canvasWidth,
					height: @gameLogic.canvasHeight
				}
			}
		});
	end

	def getCurrentPlayerNumber
		if current_user == @game.player1
			return 1
		else
			return 2
		end
	end

	def input(data)
		@gameLogic.addInput(data["type"], data["id"], getCurrentPlayerNumber)
	end

	def throw_ball
		if @game.status == "running" && @gameLogic.state == "pause"
			if current_user == @game.player1 && @gameLogic.last_loser == 1
				@gameLogic.start(1)
			elsif current_user == @game.player2 && @gameLogic.last_loser == 2
				@gameLogic.start(2)
			end
		end
	end

	def receive(data)

	end

	def unsubscribed
		if @game && (@game.player1 == current_user || @game.player2 == current_user) 
			if @game && @game.status == "running"
				if @game.player1 == current_user
					@game.winner = @game.player2
				elsif @game.player2 == current_user
					@game.winner = @game.player1
				end
			end
			@game.status = "finished"
			@game.player1_pts = @gameLogic.player_scores[0]
			@game.player2_pts = @gameLogic.player_scores[1]
			@game.save
		else
			@gameLogic.removeSpec
		end
	end

end
