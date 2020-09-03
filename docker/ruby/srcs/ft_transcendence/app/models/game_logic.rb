class GameLogic
  include ActiveModel::Model


  def self.create(id, canvasWidth = 600, canvasHeight = 400, ballRadius = 10)
	@games ||= Hash.new
	if !@games.key?(id)
	  @games[:id] ||= GameLogic.new(id, canvasWidth, canvasHeight, ballRadius)
	end
	@games[:id]
  end

  def self.delete(id)
	if @games && @games.key?(id)
	  @games.except!(id)
	end
  end

  def self.search(id)
	@game = nil
	if @games && @games.key?(id)
	  @game = @games[:id]
	end
	@game
  end

  def initialize(id, canvasWidth, canvasHeight, ballRadius)
	@canvasWidth = canvasWidth
	@canvasHeight = canvasHeight
	@ballRadius = ballRadius
	@paddles = Array.new(2)
	$paddle_height = 50
	@paddles[0] = Paddle.new(5, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
	@paddles[1] = Paddle.new(@canvasWidth - 20, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
	@last_loser = rand(1..2)
	@last_collision = if @last_loser == 1 then @paddles[0] else @paddles[1] end
	@ball = Ball.new(@last_loser, @paddles[@last_loser - 1], @ballRadius)
	@player_scores = Array.new(2, 0)
	@player_nicknames = Array.new(2)
	@player_ready = [false, false]
	@state = "pause"
	@game = Game.find_by(id: id)
	@max_points = @game.max_points
	@inputs = Array.new()
	@processed_inputs = Array.new(2)
	@processed_inputs[0] = []
	@processed_inputs[1] = []
	@spec_count = 0
  end

  def canvasWidth
	@canvasWidth
  end

  def canvasHeight
	@canvasHeight
  end

  def paddles
	@paddles
  end

  def ball
	@ball
  end

  def player_scores
	@player_scores
  end

  def player_nicknames
	@player_nicknames
  end

  def player_ready
	@player_ready
  end

  def set_nicknames(player1, player2)
	@player_nicknames[0] = player1
	@player_nicknames[1] = player2
  end

  def last_loser
	@last_loser
  end

  def state
	@state
  end

  def max_points
	@max_points
  end

  def game
	@game
  end

  def spec_count
	@spec_count
  end

  def addInput(type, id, player)
	@inputs.unshift({ type: type, id: id, player: player })
  end

  def getFrontInput
	@inputs.pop
  end

  def addProcessed(player, id)
	@processed_inputs[player - 1].push(id)
  end

  def processed_inputs
	@processed_inputs
  end

  def clear_processed
	@processed_inputs[0].clear
	@processed_inputs[1].clear
  end

  def addSpec
	@spec_count += 1
  end

  def removeSpec
	@spec_count -= 1
  end

  def start(player)
	@state = "play"
	@ball.throw(player)
  end

  def reset_ball(player)
	@state = "pause"
	@ball = Ball.new(player, @paddles[player - 1], @ballRadius)
  end

  def reset_paddles
	$paddle_height = @paddles[0].height
	@paddles[0] = Paddle.new(5, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
	$paddle_height = @paddles[1].height
	@paddles[1] = Paddle.new(@canvasWidth - 20, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
  end

  def reset_all
	$loser = 0
	if @ball.posX < 0
	  @player_scores[1] += 1
	  $loser = 1
	elsif @ball.posX > @canvasWidth
	  @player_scores[0] += 1
	  $loser = 2
	end
	reset_paddles
	reset_ball($loser)
	@last_loser = $loser
	if (gameEnd)
	  designate_winner
	  if @game.mode == "ranked"
		$count = User.where("rank = ?", @game.winner.rank + 1).count
		if $count == 0 && @game.winner.rank + 1 > 0 && @game.player1.rank == @game.player2.rank
			@game.winner.rank += 1
			@game.winner.save
		else
			$tmp = @game.player2.rank
			@game.player2.rank = @game.player1.rank
			@game.player1.rank = $tmp
		end
		if @game.winner.guild
			@game.winner.guild.points += 3
			@game.winner.guild.save
		end
		@game.player1.save
		@game.player2.save
	  elsif @game.mode == "casual"
		if @game.winner.guild
			@game.winner.guild.points += 1
			@game.winner.guild.save
		end
	  end
	end
  end

  def paddle_up(nb)
	$paddle = @paddles[nb - 1]
	if $paddle.posY - $paddle.velocity > 0
	  $paddle.up
	end
	if @state == "pause" && @last_loser == nb
	  @ball.setPosY($paddle.getCenter)
	end
  end

  def paddle_down(nb)
	$paddle = @paddles[nb - 1]
	if $paddle.posY + $paddle.height + $paddle.velocity < @canvasHeight
	  $paddle.down
	end
	if @state == "pause" && @last_loser == nb
	  @ball.setPosY($paddle.getCenter)
	end
  end

  def manage_collide
	$paddle = nil
	if @ball.collidesLeft(@paddles[0].posX, @paddles[0].posY, @paddles[0].width, @paddles[0].height)
	  $paddle = @paddles[0]
	  if @ball.posX - @ball.radius < @paddles[0].posX + @paddles[0].width
		@ball.setPosX(@paddles[0].posX + @paddles[0].width + @ball.radius)
	  end
	end
	if @ball.collidesRight(@paddles[1].posX, @paddles[1].posY, @paddles[1].width, @paddles[1].height)
	  $paddle = @paddles[1]
	  if @ball.posX + @ball.radius > @paddles[1].posX
		@ball.setPosX(@paddles[1].posX - @ball.radius)
	  end
	end
	if $paddle
	  $offset = (@ball.posY + @ball.radius * 2 - $paddle.posY) / ($paddle.height + @ball.radius * 2)
	  $phi = 0.25 * Math::PI * (2 * $offset - 1)
	  @ball.setVelocityX(@ball.velocityX * -1)
	  @ball.setVelocityY(@ball.speed * Math.sin($phi))
	  if $paddle != @last_collision
		if @ball.speed < $paddle.width
		  @ball.increaseSpeed
		end
		@last_collision = $paddle
	  end
	end
  end

  def updateBallPos
	if @ball.posX < 0 || @ball.posX > @canvasWidth
	  reset_all
	else
	  manage_collide
	end
	if @ball.collidesSideArena(@canvasHeight)
		@ball.setVelocityY(@ball.velocityY * -1)
	end
	@ball.updatePos
  end

  def gameEnd
	(@player_scores[0] == @max_points || @player_scores[1] == @max_points)
  end

  def designate_winner
	if @game.status == "running"
	  @game.status = "finished"
	  if @player_scores[0] > @player_scores[1]
		@game.winner = @game.player1
	  else
		@game.winner = @game.player2
	  end
	  @game.player1_pts = @player_scores[0]
	  @game.player2_pts = @player_scores[1]
	  @game.save
	end
  end
end