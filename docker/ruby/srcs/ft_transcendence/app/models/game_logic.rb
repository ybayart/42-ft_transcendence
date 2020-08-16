class GameLogic
	include ActiveModel::Model

    def self.create(id)
      if (!@games)
        @games = Hash.new
      end
      if (!@games[id])
        @games[id] = GameLogic.new
      end
      @games[id]
    end

	def initialize()
		@canvasWidth = 600
		@canvasHeight = 600
	  	@ball = Ball.new
	  	@paddle1 = Paddle.new(1)
	  	@paddle2 = Paddle.new(2)
	end

	def paddle1()
		@paddle1
	end

	def paddle2()
		@paddle2
	end

	def ball()
		@ball
	end

	def start()
		@ball.throw
	end

	def paddle1_up()
		if (@paddle1.posY - @paddle1.velocity > 0)
			@paddle1.up
		end
	end

	def paddle1_down()
		if (@paddle1.posY + @paddle1.height + @paddle1.velocity < @canvasHeight)
			@paddle1.down
		end
	end

	def paddle2_up()
		if (@paddle2.posY - @paddle2.velocity > 0)
			@paddle2.up
		end
	end

	def paddle2_down()
		if (@paddle2.posY + @paddle2.height + @paddle2.velocity < @canvasHeight)
			@paddle2.down
		end
	end

	def updateBallPos()
		if (@ball.collidesLeft(@paddle1.posX, @paddle1.posY, @paddle1.width, @paddle1.height) || @ball.collidesRight(@paddle2.posX, @paddle2.posY, @paddle2.width, @paddle2.height))
			@ball.setVelocityX(@ball.velocityX * -1)
		end
		if (@ball.posY + @ball.velocityY - @ball.radius < 0 || @ball.posY + @ball.velocityY + @ball.radius > @canvasHeight)
			@ball.setVelocityY(@ball.velocityY * -1)
		end
		@ball.updatePos
	end

	def persisted?
    	false
 	end

end
