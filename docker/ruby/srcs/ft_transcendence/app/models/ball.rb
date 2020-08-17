class Ball
	include ActiveModel::Model

	def initialize()
		@posY = 300
		@posX = 40
		@radius = 10
		@velocityY = 0
		@velocityX = 0
		@timeLastBounce = 0
	end

	def throw()
		@velocityX = 1
	end

	def	collidesRight(x, y, width, height)
		if (@posX + @radius >= x && @posY >= y && @posY <= y + height)
			return true
		else
			return false
		end
	end

	def collidesLeft(x, y, width, height)
		if (@posX - @radius <= x + width && @posY > y && @posY < y + height)
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
