class GameChannel < ApplicationCable::Channel

  def subscribed
  	stream_from "game"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def up
  	@game = Game.first
	@game.increment!(:nb)
	ActionCable.server.broadcast('game', {content: @game.nb})
  end

  def down
  	@game = Game.first
	@game.decrement!(:nb)
	ActionCable.server.broadcast('game', {content: @game.nb})
  end
end
