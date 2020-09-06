class TournamentsController < ApplicationController
	before_action :set_tournament, only: [:show, :register]
	before_action :not_inside, only: [:register]

	# GET /tournaments
	# GET /tournaments.json
	def index
		@tournaments = Tournament.all
	end

	# GET /tournaments/1
	# GET /tournaments/1.json
	def show
	end

	def register
		if @tournament.users.count + 1 <= @tournament.max_player
			current_user.tournaments << @tournament
			$notice = 'Registered to tournament.'
		else
			$notice = 'Tournament is full.'
		end
		redirect_to @tournament, notice: $notice
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_tournament
			@tournament = Tournament.find(params[:id])
		end

		# Only allow a list of trusted parameters through.
		def tournament_params
			params.require(:tournament).permit(:mode, :max_player, :start_time, :points_award)
		end

		def not_inside
			redirect_to tournaments_path, :alert => "Already register" and return if current_user.tournaments.include?(@tournament)
		end
end
