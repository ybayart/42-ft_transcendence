class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
    Ball.initialize
    Paddle.initialize
    Ball.throw
  end

  def self.up
	Paddle.up
	ActionCable.server.broadcast('paddle', {paddlePosY: Paddle.posY})
  end

  def self.down
  	Paddle.down
	ActionCable.server.broadcast('paddle', {paddlePosY: Paddle.posY})
  end

  def receive(data)
    Ball.updatePos
	ActionCable.server.broadcast('game', {
		ballPosX: Ball.posX,
		ballPosY: Ball.posY
	})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
