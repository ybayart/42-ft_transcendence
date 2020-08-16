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
		@velocityX = 1
	end

	def	collidesRight()
		if (@posX > 100)
			return true
		else
			return false
		end
	end

	def collidesLeft()
		if (@posX < 20)
			return true
		else
			return false
		end
	end

	def updatePosTick(time)
		@posX += @velocityX
		@posY += @velocityY
		if (collidesRight || collidesLeft)
			@timeLastBounce += time
			@velocityX *= -1
		end
	end

	def updatePos(time)
		$tmp = 0;
		while ($tmp < time)
			updatePosTick($tmp)
			$tmp += 10
		end
    end

	def sendPos()
		ActionCable.server.broadcast('game', {ballPosX: Ball.posX, ballPosY: Ball.posY})
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

	def persisted?
    	false
  	end
end
