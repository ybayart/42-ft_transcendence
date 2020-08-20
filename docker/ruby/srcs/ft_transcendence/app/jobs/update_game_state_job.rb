class UpdateGameStateJob < ApplicationJob
  queue_as :default

  def perform(id)
  	@gameLogic = GameLogic.search(id)
  	if @gameLogic
  		@game = @gameLogic.game
	  end
    while @gameLogic
			@game.reload(lock: true)
    	if @game.status == "running"
    		process_inputs(@gameLogic)
		  	if @gameLogic.state == "play"
		    	@gameLogic.updateBallPos
		    end
		  end
		  send_game_state(@gameLogic, @game)
		  if @game.status == "finished"
        GameLogic.delete(id)
        if (!@game.winner)
        	Game.delete(id)
        end
	    end
	  	@gameLogic = GameLogic.search(id)
    	sleep(1.0/60.0)
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
  		input = gameLogic.getFrontInput
  	end	
  end

	def send_game_state(gameLogic, game)
		if (@game.status == "waiting")
	    ActionCable.server.broadcast("game_#{@game.id}", {
	    	status: @game.status
	    });
	  elsif (@game.status == "running")
	    ActionCable.server.broadcast("game_#{@game.id}", {
	      status: @game.status,
	      scores: {
	        player1: @gameLogic.player_scores[0],
	        player2: @gameLogic.player_scores[1]
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
	      }
	    });
	  elsif (@game.status == "finished" && @game.winner)
	    ActionCable.server.broadcast("game_#{@game.id}", {
	    	status: @game.status,
	    	winner: @game.winner.login
	    });
	  end
  end

end
