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

    def self.delete(id)
      if (@games && @games[id])
        @games.except!(id)
      end
    end

    def self.search(id)
    	@game = nil
    	if (@games && @games[id])
    		@game = @games[id]
    		puts "found"
    	end
    	@game
    end

	def initialize()
	  	@last_loser = rand(1..2)
		@canvasWidth = 600
		@canvasHeight = 600
	  	@ball = Ball.new(@last_loser)
	  	@paddle1 = Paddle.new(1)
	  	@paddle2 = Paddle.new(2)
	  	@player1_pts = 0
	  	@player2_pts = 0
	  	@state = "pause"
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

	def player1_pts()
		@player1_pts
	end

	def player2_pts()
		@player2_pts
	end

	def last_loser()
		@last_loser
	end

	def state()
		@state
	end

	def start(player)
		@state = "play"
		@ball.throw(player)
	end

    def reset_ball(player)
    	@state = "pause"
        @ball = Ball.new(player)
    end

    def reset_paddles()
    	@paddle1 = Paddle.new(1)
    	@paddle2 = Paddle.new(2)
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
        if (@ball.posX < 0 || @ball.posX > @canvasWidth)
        	$loser = 0
        	if (@ball.posX < 0)
        		@player2_pts += 1
        		$loser = 1
        	elsif (@ball.posX > @canvasWidth)
        		@player1_pts += 1
        		$loser = 2
        	end
        	reset_ball($loser)
        	reset_paddles
        	@last_loser = $loser
		else
			if (@ball.collidesLeft(@paddle1.posX, @paddle1.posY, @paddle1.width, @paddle1.height))
	            $paddle = @paddle1
	        end
	        if (@ball.collidesRight(@paddle2.posX, @paddle2.posY, @paddle2.width, @paddle2.height))
	            $paddle = @paddle2
			end
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

    def gameEnd()
        $bool = false
        if (@player1_pts == 5 || @player2_pts == 5)
            $bool = true
        end
        $bool
    end

	def persisted?
    	false
 	end

end
