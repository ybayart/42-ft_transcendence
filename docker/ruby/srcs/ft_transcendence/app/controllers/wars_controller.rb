class WarsController < ApplicationController
	before_action :in_guild, only: [:new, :create]
	before_action :set_war, only: [:show]
	before_action :not_empty, only: [:new, :create]

	# GET /wars
	# GET /wars.json
	def index
		@wars = War.all
	end

	# GET /wars/1
	# GET /wars/1.json
	def show
	end

	# GET /wars/new
	def new
		@war = War.new
	end

	# POST /wars
	# POST /wars.json
	def create
		@war = War.new(war_params)
		@war.guild1 = current_user.guild
		@war.points_to_win = 0 unless @war.points_to_win
		@war.points1 = 0 unless @war.points1
		@war.points2 = 0 unless @war.points2
		@war.state = "waiting for war times"

		respond_to do |format|
			if @war.save
				format.html { redirect_to @war, notice: 'War was successfully created.' }
				format.json { render :show, status: :created, location: @war }
			else
				format.html { broadcast_errors @war, (['guild2_id', 'start_at', 'end_at', 'points_to_win', 'all_match']) }
				format.json { render json: @war.errors, status: :unprocessable_entity }
			end
		end
	end

	private
		def in_guild
			redirect_to wars_path, :alert => "You're not in a guild" and return unless current_user.guild
			redirect_to wars_path, :alert => "Missing permission" and return if current_user.guild.officers.exclude?(current_user)
		end

		# Use callbacks to share common setup or constraints between actions.
		def set_war
			ApplicationController.helpers.check_war_state
			begin
				@war = War.find(params[:id])
			rescue
				redirect_to wars_path, :alert => "War not found" and return
			end
		end

		# Only allow a list of trusted parameters through.
		def war_params
			params.require(:war).permit(:guild2_id, :start_at, :end_at, :points_to_win, :all_match)
		end

		def not_empty
			redirect_to wars_path, :alert => "No guild available" and return if (Guild.all.where.not(id: current_user.guild)).empty?
		end
end
