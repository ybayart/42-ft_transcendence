class War::TimesController < ApplicationController
	before_action :set_war
	before_action :set_war_time, only: [:edit, :update, :destroy]
	before_action :authored, only: [:new, :create, :edit, :update, :destroy]

	# GET /war/times
	# GET /war/times.json
	def index
		@war_times = @war.war_times
	end

	# GET /war/times/new
	def new
		@war_time = WarTime.new
	end

	# GET /war/times/1/edit
	def edit
	end

	# POST /war/times
	# POST /war/times.json
	def create
		@war_time = WarTime.new(war_time_params)
		@war_time.war = @war

		respond_to do |format|
			if @war_time.save
				back_page = war_times_path(@war)
				back_page = URI(request.referer).path if params[:back]
				format.html { redirect_to back_page, notice: 'Time was successfully created.' }
				format.json { render :show, status: :created, location: back_page }
			else
				format.html { broadcast_errors @war_time, (['start_at', 'end_at']) }
				format.json { render json: @war_time.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /war/times/1
	# PATCH/PUT /war/times/1.json
	def update
		respond_to do |format|
			if @war_time.update(war_time_params)
				back_page = war_times_path(@war)
				back_page = URI(request.referer).path if params[:back]
				format.html { redirect_to back_page, notice: 'Time was successfully updated.' }
				format.json { render :show, status: :ok, location: back_page }
			else
				format.html { broadcast_errors @war_time, (['start_at', 'end_at']) }
				format.json { render json: @war_time.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /war/times/1
	# DELETE /war/times/1.json
	def destroy
		@war_time.destroy
		respond_to do |format|
			format.html { redirect_to war_times_url, notice: 'Time was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_war
			begin
				@war = War.find(params[:war_id])
			rescue
				redirect_to wars_path, :alert => "War not found" and return
			end
		end
	
		# Use callbacks to share common setup or constraints between actions.
		def set_war_time
			@war_time = WarTime.find(params[:id])
		end

		# Only allow a list of trusted parameters through.
		def war_time_params
			params.require(:war_time).permit(:start_at, :end_at, :max_unanswered)
		end

		def authored
			redirect_to war_times_path, :alert => "Missing permission" and return if @war.guild1.officers.exclude?(current_user)
			redirect_to war_times_path, :alert => "It's not the time to do that" and return unless @war.state == "waiting for war times"
		end
end
