class Paddle
	include ActiveModel::Model

	def initialize(player_number)
		if (player_number == 1)
			@posX = 5
		elsif (player_number == 2)
			@posX = 300
		end
		@posY = 50
		@height = 50
		@width = 15
		@velocity = 5
	end

	def	up()
		@posY -= (1 * velocity)
	end

	def down()
		@posY += (1 * velocity)
	end

	def posX()
		@posX
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
