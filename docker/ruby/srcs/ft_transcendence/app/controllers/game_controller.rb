class GameController < ApplicationController

	def index
		ActionCable.server.broadcast('game', {content: "player connected"});
	end
end
