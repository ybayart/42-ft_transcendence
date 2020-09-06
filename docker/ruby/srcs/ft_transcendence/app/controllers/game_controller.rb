class GameController < ApplicationController
	before_action :set_game, only: [:show, :spectate]
	before_action :in_past, only: [:show]

	def index
		@games = Game.all.order("id DESC")
	end

	def show
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

	def set_game
		begin
			@game = Game.find(params[:id])
		rescue
			redirect_to games_path
		end
	end

	def in_past
		begin
			back_page = URI(request.referer).path
		rescue
			back_page = games_path
		end
		redirect_to back_page, :alert => "Not started" and return if @game.start_time and @game.start_time.future?
	end
	
end
