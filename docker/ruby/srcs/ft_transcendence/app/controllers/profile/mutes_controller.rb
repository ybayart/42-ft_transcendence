class Profile::MutesController < ApplicationController
	before_action :set_profile
	before_action :is_mine
	before_action :not_empty, only: [:new, :create]

	# GET /profile/mutes
	# GET /profile/mutes.json
	def index
		@profile_mutes = @profile.mutes.order("nickname ASC")
	end

	# GET /profile/mutes/new
	def new
		@profile_mute = Muteship.new
	end

	# POST /profile/mutes
	# POST /profile/mutes.json
	def create
		@profile_mute = Muteship.new(profile_mute_params)
		@profile_mute.user = current_user

		respond_to do |format|
			if @profile_mute.save
				back_page = profile_mutes_path
				back_page = URI(request.referer).path if params[:back]
				format.html { redirect_to back_page, notice: 'Mute was successfully created.' }
				format.json { render :show, status: :created, location: back_page }
			else
				format.html { broadcast_errors @profile_mute, profile_mute_params }
				format.json { render json: @profile_mute.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /profile/mutes/1
	# DELETE /profile/mutes/1.json
	def destroy
		@profile.mutes.destroy(params[:id])
		respond_to do |format|
			back_page = profile_mutes_path
			back_page = URI(request.referer).path if params[:back]
			format.html { redirect_to back_page, notice: 'Mute was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_profile
			begin
				@profile = User.find(params[:profile_id])
			rescue
				redirect_to profile_mutes_path(current_user) and return
			end
		end

		def is_mine
			redirect_to profile_path(@profile), :alert => "It's not you :)" and return unless @profile == current_user
		end

		# Only allow a list of trusted parameters through.
		def profile_mute_params
			params.require(:muteship).permit(:muted_id)
		end

		def not_empty
			redirect_to profile_mutes_path, :alert => "No user to add" and return if (User.where.not(id: @profile.id) - @profile.mutes).empty?
		end
end
