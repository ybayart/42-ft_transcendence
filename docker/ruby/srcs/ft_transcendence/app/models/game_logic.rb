class GameLogic
	include ActiveModel::Model

	def initialize()
	  	@ball = Ball.new
	  	@paddle1 = Paddle.new
	  	@paddle2 = Paddle.new
	    @ball.throw
	end

	def paddle1()
		@paddle1
	end

	def paddle2()
		@paddle2
	end

	def ball()
		@Ball
	end

	def persisted?
    	false
 	end

end
