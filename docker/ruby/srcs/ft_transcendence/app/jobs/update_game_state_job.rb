class UpdateGameStateJob < ApplicationJob
	queue_as :default

 	def perform(id)
		@gameLogic = GameLogic.search(id)
		if @gameLogic
			@game = @gameLogic.game
		end
   		$i = 0
		while @gameLogic
            if $i >= 100
			  @game.reload(lock: true)
              $i = 0
            end
			if @game.status == "waiting"
				if @gameLogic.player_ready[0] && @gameLogic.player_ready[1]
					@game.status = "running"
					@game.save
				end
			elsif @game.status == "running"
				process_inputs(@gameLogic)
			  	if @gameLogic.state == "play"
					@gameLogic.updateBallPos
			    end
			elsif @game.status == "finished"
				GameLogic.delete(id)
				if (!@game.winner)
					Game.delete(id)
				end
			end
			send_game_state(@gameLogic, @game)
		  	@gameLogic = GameLogic.search(id)
            $i += 10
			sleep(1.0/20.0)
		end
	end

	def process_inputs(gameLogic)
		input = gameLogic.getFrontInput
		while input
			if input[:type] == "paddle_up"
				gameLogic.paddle_up(input[:player])
			elsif input[:type] == "paddle_down"
				gameLogic.paddle_down(input[:player])
			end
			gameLogic.addProcessed(input[:player], input[:id])
			input = gameLogic.getFrontInput
		end	
	end

	def send_game_state(gameLogic, game)
		if (@game.status == "waiting")
			$status = @game.status
			if !@gameLogic.player_ready[0] && @gameLogic.player_ready[1]
				$status = "waiting for #{@gameLogic.player_nicknames[0]}"
			elsif @gameLogic.player_ready[0] && !@gameLogic.player_read[1]
				$status = "waiting for #{@gameLogic.player_nicknames[1]}"
			end
			ActionCable.server.broadcast("game_#{@game.id}", {
				status: $status,
				player2: @game.player2 ? @game.player2.nickname : nil
			});
		elsif (@game.status == "running")
			if @gameLogic.player_nicknames[0] == nil
				@gameLogic.set_nicknames(@game.player1.nickname, @game.player1.nickname)
			end
			ActionCable.server.broadcast("game_#{@game.id}", {
				status: @game.status,
				players: {
					nicknames: [
						@gameLogic.player_nicknames[0],
						@gameLogic.player_nicknames[1]
					],
					scores: [
						@gameLogic.player_scores[0],
						@gameLogic.player_scores[1]
					]
				},
				paddles: [
				{
					posX: @gameLogic.paddles[0].posX,
					posY: @gameLogic.paddles[0].posY,
					width: @gameLogic.paddles[0].width,
					height: @gameLogic.paddles[0].height,
					velocity: @gameLogic.paddles[0].velocity
				},
				{
					posX: @gameLogic.paddles[1].posX,
					posY: @gameLogic.paddles[1].posY,
					width: @gameLogic.paddles[1].width,
					height: @gameLogic.paddles[1].height,
					velocity: @gameLogic.paddles[1].velocity
				}
				],
				ball: {
					posX: @gameLogic.ball.posX,
					posY: @gameLogic.ball.posY,
					radius: @gameLogic.ball.radius
				},
				inputs: [
					@gameLogic.processed_inputs[0],
					@gameLogic.processed_inputs[1]
				],
				spec_count: @gameLogic.spec_count
			});
			@gameLogic.clear_processed
		elsif (@game.status == "finished" && @game.winner)
			ActionCable.server.broadcast("game_#{@game.id}", {
				status: @game.status,
				winner: @game.winner.nickname
			});
		end
	end

end
