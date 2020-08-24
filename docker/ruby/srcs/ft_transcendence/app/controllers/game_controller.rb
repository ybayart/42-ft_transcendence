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
    @game = Game.find_by(status: "waiting", player1: current_user);
    @game ||= Game.find_by(status: "running", player1: current_user);
    if @game
      @game.destroy
      @game = nil
    end
    @game = Game.find_by(status: "running", player2: current_user);
    @game ||= Game.find_by(status: "waiting", player2: current_user);
    if @game
      @game.destroy
      @game = nil
    end
    @game ||= Game.find_by(status: "waiting");
    if @game
      @game.player2 = current_user
      @game.status = "running"
      @game.save
    elsif !@game
      @game = Game.new
      @game.status = "waiting"
      @game.player1 = current_user
      @game.save
    end
    @game
  end

  def find_test_game
    @game = Game.find_by(status: "waiting");
    if !@game
      @game = Game.create(player1: current_user, status: "waiting");
    else
      @game.player2 = current_user;
      @game.status = "running"
      @game.save
    end
    @game
  end
  
end
