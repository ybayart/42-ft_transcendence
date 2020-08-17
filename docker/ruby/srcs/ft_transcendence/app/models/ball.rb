class Ball
	include ActiveModel::Model

	def initialize(player)
		if (player == 1)
			@posX = 40
		elsif (player == 2)
			@posX = 600 - 20 - 20
		end
		@posY = 300
		@radius = 10
		@velocityY = 0
		@velocityX = 0
	end

	def throw(player)
		if (player == 1)
			@velocityX = 1
		elsif (player == 2)
			@velocityX = -1
		end
	end

	def	collidesRight(x, y, width, height)
		if (@posX + @radius >= x && @posY + @radius >= y && @posY - @radius <= y + height)
			return true
		else
			return false
		end
	end

	def collidesLeft(x, y, width, height)
		if (@posX - @radius <= x + width && @posY + @radius >= y && @posY - @radius <= y + height)
			return true
		else
			return false
		end
	end

	def updatePos()
		@posX += @velocityX
		@posY += @velocityY
    end

	def posY()
		@posY
	end

	def posX()
		@posX
	end

	def radius
		@radius
	end

	def velocityY()
		@velocityY
	end

	def velocityX()
		@velocityX
	end

    def speed()
        return (Math.sqrt(@velocityX ** 2 + @velocityY ** 2))
    end

    def setPosY(value)
    	@posY = value
    end

	def setVelocityX(value)
		@velocityX = value
	end

	def setVelocityY(value)
		@velocityY = value
	end

    def increaseSpeed()
        @velocityX += @velocityX * 0.2
        @velocityY += @velocityY * 0.2
    end

	def persisted?
    	false
  	end
end
