class Api::RoomUsersController < ApiController
	before_action :set_room_user, only: [:show, :edit, :update, :destroy]

	# GET /room_users/1
	# GET /room_users/1.json
	def show
		render json: @room_user
	end

	# GET /room_users/new
	def new
		@room_user = Post.new
	end

	# GET /room_users/1/edit
	def edit
	end

	# POST /room_users
	# POST /room_users.json
	def create
		@room_user = Post.new(room_user_params)

		if @room_user.save
			render json: @room_user
		else
			render json: @room_user.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /room_users/1
	# PATCH/PUT /room_users/1.json
	def update
		if @room_user.update(room_user_params)
			render :show, status: :ok, location: @room_user
		else
			render json: @room_user.errors, status: :unprocessable_entity
		end
	end

	# DELETE /room_users/1
	# DELETE /room_users/1.json
	def destroy
		@room_user.destroy
		head :no_content
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_room_user
			@room_user = {'owner': Room.find(params[:id]).owner, "admins": [], "members": []}
			Room.find(params[:id]).admins.order("state DESC, nickname ASC").each do |admin|
				@room_user[:admins] << admin unless @room_user[:owner] == admin
			end
			Room.find(params[:id]).members.order("state DESC, nickname ASC").each do |member|
				@room_user[:members] << member unless @room_user[:owner] == member || @room_user[:admins].include?(member)
			end
		end

		# Only allow a list of trusted parameters through.
		def room_user_params
			params.require(:room_user).permit(:title, :content)
		end
end
