class GameChannel < ApplicationCable::Channel

  def subscribed
	stream_from "game_#{params[:game]}"
    @gameLogic = GameLogic.new
    @gameLogic.start
  end

  def player1_up
    @gameLogic.paddle1_up
  end

  def player1_down
  	@gameLogic.paddle1_down
  end

  def receive(data)
    @gameLogic.updateBallPos
		ActionCable.server.broadcast("game_#{params[:game]}", {
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
