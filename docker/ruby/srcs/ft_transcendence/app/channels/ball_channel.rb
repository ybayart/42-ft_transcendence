class BallChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ball"
    Ball.initialize
    Ball.throw
    while true
      Ball.updatePos
      Ball.sendPos
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
