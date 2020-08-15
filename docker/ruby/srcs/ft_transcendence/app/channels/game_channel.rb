class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
    Ball.initialize
    Paddle.initialize
    Ball.throw
  end

  def up
		Paddle.up
  end

  def down
  	Paddle.down
  end

  def receive(data)
    Ball.updatePos
		ActionCable.server.broadcast('game', {
			paddlePosY: Paddle.posY, 
			ballPosX: Ball.posX,
			ballPosY: Ball.posY
		})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
