class Paddle < ApplicationRecord
	def initialize()
		@posY = 50
		@height = 10
		@width = 2
		@velocity = 1
	end

	def	up()
		@posY += (1 * velocity);
	end

	def down()
		@posX -= (1 * velocity);
	end

	def posY()
		@posY
	end

	def height()
		@height
	end

	def width()
		@width
	end

	def velocity()
		@velocity
	end
end
