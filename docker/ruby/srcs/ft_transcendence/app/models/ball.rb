class Ball
	include ActiveModel::Model

	def initialize(player, paddle, radius)
		@startingSpeed = 4
		@radius = radius
		if player == 1
			@posX = paddle.posX + (paddle.width + 10 + @radius)
		elsif player == 2
			@posX = paddle.posX - (10 + @radius)
		end
		@posY = paddle.posY + paddle.height / 2
		@velocityY = 0
		@velocityX = 0
	end

	def throw(player)
		if player == 1
			@velocityX = @startingSpeed
		elsif player == 2
			@velocityX = -@startingSpeed
		end
	end

	def	collidesRight(x, y, width, height)
		(@posX + @radius >= x && @posY + @radius >= y && @posY - @radius <= y + height)
	end

	def collidesLeft(x, y, width, height)
		(@posX - @radius <= x + width && @posY + @radius >= y && @posY - @radius <= y + height)
	end

    def collidesSideArena(height)
        (@posY + @velocityY - @radius < 0 || @posY + @velocityY + @radius > height)
    end

	def updatePos
		@posX += @velocityX
		@posY += @velocityY
    end

	def posY
		@posY
	end

	def posX
		@posX
	end

	def radius
		@radius
	end

	def velocityY
		@velocityY
	end

	def velocityX
		@velocityX
	end

	def startingSpeed
		@startingSpeed
	end

    def speed
        (Math.sqrt(@velocityX ** 2 + @velocityY ** 2))
    end

    def setPosX(value)
        @posX = value
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

    def increaseSpeed
        @velocityX += @velocityX * 0.2
        @velocityY += @velocityY * 0.2
    end
end
