class GameChannel < ApplicationCable::Channel

  def subscribed
    stream_from "game_#{params[:game]}"
    @gameLogic = GameLogic.create(params[:game])
    @game = Game.find_by(status: "waiting", player1: current_user);
    @game ||= Game.find_by(status: "running", player1: current_user);
    if !@game
      @game = Game.find_by(status: "running", player2: current_user);
      @game ||= Game.find_by(status: "waiting", player2: current_user);
      UpdateBallJob.perform_later(params[:game])
    end
  end

  def paddle_up
    if current_user == @game.player1
      @gameLogic.paddle_up(1)
    elsif current_user == @game.player2
      @gameLogic.paddle_up(2)
    end
  end

  def paddle_down
    if current_user == @game.player1
      @gameLogic.paddle_down(1)
    elsif current_user == @game.player2
      @gameLogic.paddle_down(2)
    end
  end

  def throw_ball
    if @game.status == "running" && @gameLogic.state == "pause"
      if current_user == @game.player1 && @gameLogic.last_loser == 1
        @gameLogic.start(1)
      elsif current_user == @game.player2 && @gameLogic.last_loser == 2
        @gameLogic.start(2)
      end
    end
  end

  def update_game
    @game = Game.find_by(id: @game.id)
  end

  def designate_winner
    if @game.status == "running"
     @game.status = "finished"
     if @gameLogic.player_scores[0] > @gameLogic.player_scores[1]
       @game.winner = @game.player1
     else
       @game.winner = @game.player2
     end
     @game.player1_pts = @gameLogic.player_scores[0];
     @game.player2_pts = @gameLogic.player_scores[1];
     @game.save
   end
  end

  def send_all_infos
   ActionCable.server.broadcast("game_#{params[:game]}", {
     status: @game.status,
     player1_pts: @gameLogic.player_scores[0],
     player2_pts: @gameLogic.player_scores[1],
     paddle1PosX: @gameLogic.paddles[0].posX,
     paddle1PosY: @gameLogic.paddles[0].posY,
     paddle1Width: @gameLogic.paddles[0].width,
     paddle1Height: @gameLogic.paddles[0].height,
     paddle2PosX: @gameLogic.paddles[1].posX,
     paddle2PosY: @gameLogic.paddles[1].posY,
     paddle2Width: @gameLogic.paddles[1].width,
     paddle2Height: @gameLogic.paddles[1].height,
     ballPosX: @gameLogic.ball.posX,
     ballPosY: @gameLogic.ball.posY,
     ballRadius: @gameLogic.ball.radius
   })
  end

  def send_winner_login
   ActionCable.server.broadcast("game_#{params[:game]}", {
     winner: @game.winner.login
   })
  end

  def receive(data)
   if @game.status == "waiting"
     update_game
   end
   if @game.status != "finished"
     @gameLogic.updateBallPos
     send_all_infos
     if @gameLogic.gameEnd
       designate_winner
       send_winner_login
       GameLogic.delete(params[:game])
     end
   else
     send_winner_login
   end
  end

  def unsubscribed
   if @game.status == "waiting"
     @game.destroy
   end
   if @game.status == "running"
     @game.status = "finished"
     if @game.player1 == current_user
       @game.winner = @game.player2
     elsif @game.player2 == current_user
       @game.winner = @game.player1
     end
     @game.player1_pts = @gameLogic.player1_pts;
     @game.player2_pts = @gameLogic.player2_pts;
     @game.save
     send_winner_login
   end
   GameLogic.delete(params[:game])
  end

end
