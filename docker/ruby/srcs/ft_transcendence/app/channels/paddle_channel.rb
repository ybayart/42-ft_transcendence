class PaddleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "paddle"
		# Paddle.initialize
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def up
  	GameChannel.up
  end

  def down
  	GameChannel.down
  end
end
