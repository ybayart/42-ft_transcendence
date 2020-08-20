class Api::RoomSettingsController < ApiController
	before_action :set_room_setting, only: [:show, :update]

	# GET /room_settings/1
	# GET /room_settings/1.json
	def show
		render json: @room_setting
	end

	# PATCH/PUT /room_settings/1
	# PATCH/PUT /room_settings/1.json
	def update
		if @room_setting.update(room_setting_params)
			render :show, status: :ok, location: @room_setting
		else
			render json: @room_setting.errors, status: :unprocessable_entity
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_room_setting
			@room_setting = Room.find(params[:id]).slice(:name, :privacy)
		end

		# Only allow a list of trusted parameters through.
		def room_setting_params
			params.require(:room_setting).permit(:name, :privacy, :password)
		end
end
