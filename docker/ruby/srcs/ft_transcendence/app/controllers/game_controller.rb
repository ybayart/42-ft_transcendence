class GameController < ApplicationController

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)
    redirect_to game_path
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
    @game = Game.find_by("player1_id != ? AND status = ?", current_user, "waiting");
    if !@game
      @game = Game.create(player1: current_user, status: "waiting", mode: "casual", creator_id: current_user.id);
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
      @game = Game.create(player1: current_user, status: "waiting", mode: "casual", creator_id: current_user.id);
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
