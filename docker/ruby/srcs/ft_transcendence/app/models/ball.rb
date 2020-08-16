class Ball
	include ActiveModel::Model

	def initialize()
		@posY = 50
		@posX = 20
		@radius = 10
		@velocityY = 0
		@velocityX = 0
		@timeLastBounce = 0
	end

	def throw()
		@velocityX = 3
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

	def setVelocityX(value)
		@velocityX = value
	end

	def persisted?
    	false
  	end
end
