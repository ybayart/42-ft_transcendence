class Paddle
	include ActiveModel::Model

	def initialize()
		@posY = 50
		@height = 10
		@width = 2
		@velocity = 5
	end

	def	up()
		@posY -= (1 * velocity)
	end

	def down()
		@posY += (1 * velocity)
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

	def persisted?
    	false
 	end
end
