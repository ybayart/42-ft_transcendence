class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
	@ball = Ball.new;
	@paddle = Paddle.new;
    @ball.throw
  end

  def up
	@paddle.up
	ActionCable.server.broadcast('paddle', {paddlePosY: @paddle.posY})
  end

  def down
  	@paddle.down
	ActionCable.server.broadcast('paddle', {paddlePosY: @paddle.posY})
  end

  def receive(data)
    @ball.updatePos(data.time)
	if (@ball.posX != data.ballPosX || @ball.posY != data.ballPosY)
		ActionCable.server.broadcast('game', {
			ballPosX: @ball.posX,
			ballPosY: @ball.posY,
			velocityX: @ball.velocityX,
			velocityY: @ball.velocityY
		})
	end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
