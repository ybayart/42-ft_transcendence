class GameChannel < ApplicationCable::Channel

  def subscribed
	stream_from "game_#{params[:game]}"
    @gameLogic = GameLogic.create(params[:game])
	@game = Game.find_by(player1: current_user);
	if (!@game)
		@game = Game.find_by(player2: current_user);
        @gameLogic.start
	end
  end

  def paddle_up
    if (current_user == @game.player1)
      @gameLogic.paddle1_up
    else
      if (current_user == @game.player2)
        @gameLogic.paddle2_up
      end
    end
  end

  def paddle_down
  	if (current_user == @game.player1)
      @gameLogic.paddle1_down
    else
      if (current_user == @game.player2)
        @gameLogic.paddle2_down
      end
    end
  end

  def receive(data)
    @gameLogic.updateBallPos
		ActionCable.server.broadcast("game_#{params[:game]}", {
            status: @game.status,
			paddle1PosX: @gameLogic.paddle1.posX,
			paddle1PosY: @gameLogic.paddle1.posY,
			paddle1Width: @gameLogic.paddle1.width,
		    paddle1Height: @gameLogic.paddle1.height,
		    paddle2PosX: @gameLogic.paddle2.posX,
			paddle2PosY: @gameLogic.paddle2.posY,
			paddle2Width: @gameLogic.paddle2.width,
			paddle2Height: @gameLogic.paddle2.height,
			ballPosX: @gameLogic.ball.posX,
			ballPosY: @gameLogic.ball.posY,
			ballRadius: @gameLogic.ball.radius
		})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
