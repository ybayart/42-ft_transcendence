class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
    @game = GameLogic.new
  end

  def player1_up
    @game.paddle1.up
    ActionCable.server.broadcast('paddle', {paddlePosY: @game.paddle1.posY})
  end

  def player1_down
  	@game.paddle1.down
    ActionCable.server.broadcast('paddle', {paddlePosY: @game.paddle1.posY})
  end

  def receive(data)
    @game.ball.updatePos(data["time"])
    if (@game.ball.posX != data["ballPosX"] || @game.ball.posY != data["ballPosY"])
  		ActionCable.server.broadcast('game', {
  			ballPosX: @game.ball.posX,
  			ballPosY: @game.ball.posY,
  			velocityX: @game.ball.velocityX,
  			velocityY: @game.ball.velocityY
  		})
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
