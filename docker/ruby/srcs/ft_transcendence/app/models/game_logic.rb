class GameLogic
  include ActiveModel::Model

  def self.create(id)
    @games ||= Hash.new
    if !@games[id]
      @games[id] ||= GameLogic.new(id)
    end
    @games[id]
  end

  def self.delete(id)
    if @games && @games[id]
      @games.except!(id)
    end
  end

  def self.search(id)
    @game = nil
    if @games && @games[id]
      @game = @games[id]
    end
    @game
  end

  def initialize(id)
    @canvasWidth = 600
    @canvasHeight = 600
    @paddles = Array.new(2)
    @paddles[0] = Paddle.new(1)
    @paddles[1] = Paddle.new(2)
    @last_loser = rand(1..2)
    @last_collision = if @last_loser == 1 then @paddles[0] else @paddles[1] end
    @ball = Ball.new(@last_loser)
    @player_scores = Array.new(2, 0)
    @state = "pause"
    @game = Game.find_by(id: id);
    @inputs = Array.new();
    @processed_inputs = Array.new(2);
    @processed_inputs[0] = [];
    @processed_inputs[1] = [];
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

  def last_loser
    @last_loser
  end

  def state
    @state
  end

  def game
    @game
  end

  def addInput(type, id, player)
    @inputs.unshift({ type: type, id: id, player: player });
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

  def start(player)
    @state = "play"
    @ball.throw(player)
  end

  def reset_ball(player)
    @state = "pause"
    @ball = Ball.new(player)
  end

  def reset_paddles
    @paddles[0] = Paddle.new(1)
    @paddles[1] = Paddle.new(2)
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
    reset_ball($loser)
    reset_paddles
    @last_loser = $loser
    if (gameEnd)
      designate_winner
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
        @ball.increaseSpeed
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
    (@player_scores[0] == 5 || @player_scores[1] == 5)
  end

  def designate_winner
    if @game.status == "running"
      @game.status = "finished"
      if @player_scores[0] > @player_scores[1]
        @game.winner = @game.player1
      else
        @game.winner = @game.player2
      end
      @game.player1_pts = @player_scores[0];
      @game.player2_pts = @player_scores[1];
      @game.save
    end
  end

end
