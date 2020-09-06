class GameLogic
  include ActiveModel::Model

  @@semaphore = Mutex.new
  @@games = Hash.new

  def self.create(id)
	@@semaphore.synchronize {
		if !@@games.has_key?(id)
			$game = Game.find_by(id: id)
			if !$game.game_rules
				$game_rules = GameRule.create()
				$game.game_rules = $game_rules
				$game.save
			end
		  @@games[id] ||= GameLogic.new(id)
		end
	}
	@@games[id]
  end

  def self.delete(id)
	@@semaphore.synchronize {
		if @@games && @@games.has_key?(id)
		  @@games.delete(id)
		end
	}
  end

  def self.search(id)
	@@semaphore.synchronize {
		$game = nil
		if @@games && @@games.has_key?(id)
		  $game = @@games[id]
		end
		$game
	}
  end

  def self.check_rules(rules)
	if rules["max_points"].to_i < 1 || rules["max_points"].to_i > 20
		return false
	end
	if rules["canvas"]["width"].to_i < 200 || rules["canvas"]["width"].to_i > 3000
		return false
	end
	if rules["canvas"]["height"].to_i < 200 || rules["canvas"]["height"].to_i > 3000
		return false
	end
	if rules["ball"]["radius"].to_i < 1 || (rules["ball"]["radius"].to_i * 2) > rules["canvas"]["height"].to_i || (rules["ball"]["radius"].to_i * 2) > rules["canvas"]["width"].to_i
		return false
	end
	return true
  end

  def initialize(id)
	@game = Game.find_by(id: id)
	@canvasWidth = @game.game_rules.canvas_width
	@canvasHeight = @game.game_rules.canvas_height
	@ballRadius = @game.game_rules.ball_radius
	@paddles = Array.new(2)
	$paddle_height = 50.0
	@paddles[0] = Paddle.new(5, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
	@paddles[1] = Paddle.new(@canvasWidth - 20, @canvasHeight / 2 - ($paddle_height / 2), $paddle_height)
	@last_loser = rand(1..2)
	@last_collision = if @last_loser == 1 then @paddles[0] else @paddles[1] end
	@ball = Ball.new(@last_loser, @paddles[@last_loser - 1], @ballRadius)
	@player_scores = Array.new(2, 0)
	@player_nicknames = Array.new(2)
	@player_ready = [false, false]
	@state = "pause"
	@max_points = @game.game_rules.max_points
	@inputs = Array.new()
	@processed_inputs = Array.new(2)
	@processed_inputs[0] = []
	@processed_inputs[1] = []
	@spec_count = 0
	UpdateGameStateJob.perform_later(id)
  end

  def send_config
	ActionCable.server.broadcast("game_#{@game.id}", {
		config:
		{
			canvas:
			{
				width: @canvasWidth,
				height: @canvasHeight
			},
			paddles: [
				{
					width: @paddles[0].width,
					height: @paddles[0].height,
					velocity: @paddles[0].velocity
				},
				{
					width: @paddles[1].width,
					height: @paddles[1].height,
					velocity: @paddles[1].velocity
				}
			],
			ball:
			{
				speed: @ball.startingSpeed,
				radius: @ball.radius
			},
			max_points: @max_points
		}
	})
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
	  attribute_points
	end
  end

  def change_rank(player)
	if player.mmr <= 1000
		player.rank = 5
	elsif player.mmr > 1000 && player.mmr <= 1200
		player.rank = 4
	elsif player.mmr > 1200 && player.mmr <= 1400
		player.rank = 3
	elsif player.mmr > 1400 && player.mmr <= 1600
		player.rank = 2
	elsif player.mmr > 1600 && player.mmr <= 1800
		player.rank = 1
	end
  end

  def attribute_points
	if @game.mode == "ranked"
		$winner = @game.winner
		if @game.winner == @game.player1
			$loser = @game.player2
		elsif @game.winner == @game.player2
			$loser = @game.player1
		end
		$const = 40
		$factor = 1.0 / (1.0 + 10.0 ** (($winner.mmr - $loser.mmr) / 400.0))
		$winner.mmr += $const * $factor
		$loser.mmr -= $const * $factor
		change_rank($winner)
		change_rank($loser)
		$winner.save
		$loser.save
		if @game.winner.guild
			@game.winner.guild.points += 3
			@game.winner.guild.save
		end
	elsif @game.mode == "casual"
		if @game.winner.guild
			@game.winner.guild.points += 1
			@game.winner.guild.save
		end
	elsif @game.mode == "war"
		@war_time = WarTimeLinkGame.find_by(game: @game).war_time
		if @game.winner == @game.player1
		  @war_time.war.increment!(:points1, 1)
		else
		  @war_time.war.increment!(:points2, 1)
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
	  $offset = (@ball.posY + @ball.radius * 2.0 - $paddle.posY) / ($paddle.height + @ball.radius * 2.0)
	  $phi = 0.25 * Math::PI * (2.0 * $offset - 1.0)
	  @ball.setVelocityX(@ball.velocityX * -1.0)
	  if @ball.velocityY != 0 || @ball.posY != $paddle.getCenter
		@ball.setVelocityY(@ball.speed * Math.sin($phi))
	  end
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
