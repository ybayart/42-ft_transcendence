class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
    @game = GameLogic.new
  end

  def player1_up
    @game.paddle1.up
  end

  def player1_down
  	@game.paddle1.down
  end

  def receive(data)
    @game.updateBallPos
		ActionCable.server.broadcast('game', {
      paddle1PosX: @game.paddle1.posX,
      paddle1PosY: @game.paddle1.posY,
      paddle1Width: @game.paddle1.width,
      paddle1Height: @game.paddle1.height,
      paddle2PosX: @game.paddle2.posX,
      paddle2PosY: @game.paddle2.posY,
      paddle2Width: @game.paddle2.width,
      paddle2Height: @game.paddle2.height,
			ballPosX: @game.ball.posX,
			ballPosY: @game.ball.posY,
      ballRadius: @game.ball.radius
		})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
