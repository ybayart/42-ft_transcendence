class Paddle
	include ActiveModel::Model

	def initialize(x, y, h)
		@posX = x
		@posY = y
		@height = h
		@width = 15.0
		@velocity = 10
	end

	def	up
		@posY -= (1 * @velocity)
	end

	def down
		@posY += (1 * @velocity)
	end

	def posX
		@posX
	end

	def posY
		@posY
	end

	def height
		@height
	end

	def width
		@width
	end

	def velocity
		@velocity
	end

	def getCenter
		return (@posY + @height / 2.0)
	end
end
