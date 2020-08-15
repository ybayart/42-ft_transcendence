class Ball < ApplicationRecord
	def self.initialize()
		@posY = 50
		@posX = 20
		@radius = 10
		@velocityY = 0
		@velocityX = 0
	end

	def self.throw()
		@velocityX = 1
	end

	def	self.collidesRight()
		if (@posX > 100)
			return true
		else
			return false
		end
	end

	def self.collidesLeft()
		if (@posX < 20)
			return true
		else
			return false
		end
	end

	def self.updatePos()
		@posX += velocityX
		@posY += velocityY
		if (self.collidesRight || self.collidesLeft)
			@velocityX *= -1
      	end
    end

	def self.sendPos()
		ActionCable.server.broadcast('game', {ballPosX: Ball.posX, ballPosY: Ball.posY})
	end

	def self.posY()
		@posY
	end

	def self.posX()
		@posX
	end

	def self.radius
		@radius
	end

	def self.velocityY()
		@velocityY
	end

	def self.velocityX()
		@velocityX
	end

end
