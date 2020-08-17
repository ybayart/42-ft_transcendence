class GameChannel < ApplicationCable::Channel

  def subscribed
    stream_from "game_#{params[:game]}"
    @gameLogic = GameLogic.create(params[:game])
    @game = Game.find_by(status: "waiting", player1: current_user);
    @game ||= Game.find_by(status: "running", player1: current_user);
    if (!@game)
      @game = Game.find_by(status: "running", player2: current_user);
      @game ||= Game.find_by(status: "waiting", player2: current_user);
      UpdateBallJob.perform_later(params[:game])
    end
  end

  def paddle_up
    if (current_user == @game.player1)
      @gameLogic.paddle1_up
    else
      if (current_user == @game.player2)
        @gameLogic.paddle2_up
      end
    end
  end

  def paddle_down
    if (current_user == @game.player1)
      @gameLogic.paddle1_down
    else
      if (current_user == @game.player2)
        @gameLogic.paddle2_down
      end
    end
  end

  def throw_ball
    if (@game.status == "running" && @gameLogic.state == "pause")
      if (current_user == @game.player1)
        if (@gameLogic.last_loser == 1)
          @gameLogic.start(1)
        end
      elsif (current_user == @game.player2)
        if (@gameLogic.last_loser == 2)
          @gameLogic.start(2)
        end
      end
    end
  end

  def end
    @game = Game.find_by(id: @game.id)
  end

  def designate_winner
    if (@game.status == "running")
      @game.status = "finished"
      if (@gameLogic.player1_pts > @gameLogic.player2_pts)
        @game.winner = @game.player1
     else
       @game.winner = @game.player2
     end
     @game.save
   end
  end

  def receive(data)
   if (@game.status == "waiting")
     @game = Game.find_by(id: @game.id)
   end
   if (@game.status != "finished")
     @gameLogic.updateBallPos
     ActionCable.server.broadcast("game_#{params[:game]}", {
       status: @game.status,
       player1_pts: @gameLogic.player1_pts,
       player2_pts: @gameLogic.player2_pts,
       paddle1PosX: @gameLogic.paddle1.posX,
       paddle1PosY: @gameLogic.paddle1.posY,
       paddle1Width: @gameLogic.paddle1.width,
       paddle1Height: @gameLogic.paddle1.height,
       paddle2PosX: @gameLogic.paddle2.posX,
       paddle2PosY: @gameLogic.paddle2.posY,
       paddle2Width: @gameLogic.paddle2.width,
       paddle2Height: @gameLogic.paddle2.height,
       ballPosX: @gameLogic.ball.posX,
       ballPosY: @gameLogic.ball.posY,
       ballRadius: @gameLogic.ball.radius
     })
     if (@gameLogic.gameEnd())
       designate_winner
       ActionCable.server.broadcast("game_#{params[:game]}", {
         winner: @game.winner.login
       })
       GameLogic.delete(params[:game])
     end
   else      
     ActionCable.server.broadcast("game_#{params[:game]}", {
       winner: @game.winner.login
     })
   end
  end

  def unsubscribed
   if (@game.status == "running")
     @game.status = "finished"
     if (@game.player1 == current_user)
       @game.winner = @game.player2
     elsif (@game.player2 == current_user)
       @game.winner = @game.player1
     end
     @game.save
   end
   ActionCable.server.broadcast("game_#{params[:game]}", {
     winner: @game.winner.login
   })
   GameLogic.delete(params[:game])
  end

end
