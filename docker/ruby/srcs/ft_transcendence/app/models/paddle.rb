class Paddle < ApplicationRecord
	def self.initialize()
		@posY = 50
		@height = 10
		@width = 2
		@velocity = 1
	end

	def	self.up()
		@posY += (1 * velocity)
		ActionCable.server.broadcast('game', {content: Paddle.posY})
	end

	def self.down()
		@posY -= (1 * velocity)
		ActionCable.server.broadcast('game', {content: Paddle.posY})
	end

	def self.posY()
		@posY
	end

	def self.height()
		@height
	end

	def self.width()
		@width
	end

	def self.velocity()
		@velocity
	end
end
