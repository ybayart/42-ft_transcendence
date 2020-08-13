class PaddleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "paddle"
	Paddle.initialize
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def up
  	Paddle.up
  end

  def down
  	Paddle.down
  end
end
