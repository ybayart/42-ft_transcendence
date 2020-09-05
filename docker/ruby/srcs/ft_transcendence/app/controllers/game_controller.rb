class GameController < ApplicationController

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def spectate
    @game = Game.find(params[:id])
  end

  def play
    find_game
  end

  def test
    find_test_game
  end

  def find_game
    @game = Game.find_by("player1_id != ? AND status = ? AND mode = ?", current_user, "waiting", "casual");
    if !@game
      @game = Game.create(player1: current_user, status: "waiting", mode: "casual");
    else
      @game.player2 = current_user;
      @game.status = "running"
      @game.save
    end
    @game
  end

  def find_test_game
    @game = Game.find_by(status: "waiting");
    if !@game
      @game = Game.create(player1: current_user, status: "waiting", mode: "casual");
    else
      @game.player2 = current_user;
      @game.status = "running"
      @game.save
    end
    @game
  end

  private

  def game_params
    params.require(:game).permit(:max_points)
  end
  
end
