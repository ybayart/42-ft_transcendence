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
	  	@player1_pts = 0
	  	@player2_pts = 0
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

	def player1_pts
		@player1_pts
	end

	def player2_pts
		@player2_pts
	end

	def start()
		@ball.throw
	end

    def reset_ball()
        @ball = Ball.new
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
        $paddle = nil
		if (@ball.collidesLeft(@paddle1.posX, @paddle1.posY, @paddle1.width, @paddle1.height))
            $paddle = @paddle1
        end
        if (@ball.collidesRight(@paddle2.posX, @paddle2.posY, @paddle2.width, @paddle2.height))
            $paddle = @paddle2
		end
        if (@ball.posX < 0 || @ball.posX > @canvasWidth)
        	if (@ball.posX < 0)
        		@player2_pts += 1
        	elsif (@ball.posX > @canvasWidth)
        		@player1_pts += 1
        	end
            reset_ball
            start
        end
        if ($paddle)
            $offset = (@ball.posY + @ball.radius * 2 - $paddle.posY) / ($paddle.height + @ball.radius * 2)
            $phi = 0.25 * Math::PI * (2 * $offset - 1)
            @ball.setVelocityX(@ball.velocityX * -1)
            @ball.setVelocityY(@ball.speed * Math.sin($phi))
            #$relativeIntersectY = ($paddle.posY + ($paddle.height / 2)) - @ball.posY
            #$normalizedRelativeIntersectionY = ($relativeIntersectY/($paddle.height/2))
            #$bounceAngle = $normalizedRelativeIntersectionY * 75
            #@ball.setVelocityX(@ball.speed * Math.cos($bounceAngle))
            #@ball.setVelocityY(@ball.speed * -Math.sin($bounceAngle))
            @ball.increaseSpeed
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
