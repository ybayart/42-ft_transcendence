class PaddleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "paddle"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
