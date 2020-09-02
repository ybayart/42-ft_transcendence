class RoomsController < ApplicationController
	before_action :load_entities
	before_action :check_member, only: [:show, :password]
	before_action :is_owner, only: [:destroy]

	def index
	end

	def password
	end

	def passwordset
		session[:room_passwords][@room.id.to_s] = params[:password]
		redirect_to room_path(@room)
	end

	def show
		pass = BCrypt::Password.new(@room.password)
		redirect_to password_room_path(@room.id), :alert => "Protected by a password" and return if pass != "" and pass != session[:room_passwords][@room.id.to_s]
		bans = current_user.receive_bans.where("room": @room).where("end_at > ?", DateTime.now.utc)
		redirect_to rooms_path, :alert => "You are banned from this room until " + bans.order("end_at DESC").first.end_at.in_time_zone("Europe/Paris").strftime("%T %F") and return if bans.exists?
		unless @room.members.include?(current_user)
			@room.members << current_user
		end
		@room_message = RoomMessage.new room: @room
		@room_messages = @room.room_messages.where("user_id NOT IN (?)", current_user.mutes.map(&:id)).includes(:user)
	end

	def new
		@room = Room.new
	end

	def join
		@rooms = Room.where(privacy: "public").where.not(id: current_user.rooms_member)
	end

	def create
		@room = Room.new room_params
		@room.owner = current_user

		respond_to do |format|
			if @room.save
				format.html { redirect_to @room, notice: 'Room was successfully created.' }
				format.json { render :show, status: :created, location: @room }
			else
				format.html { broadcast_errors @room, room_params }
				format.json { render json: @room.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		redirect_to rooms_path, :alert => "Not your room!" and return unless @room.owner == current_user
	end

	def update
		if @room.owner == current_user
			if @room.update_attributes(room_params)
				flash[:success] = "Room #{@room.name} was updated successfully"
				redirect_to rooms_path
			else
				render :new
			end
		else
			render json: {"status": "error", "error": "403: Forbidden"}, status: :forbidden
		end
	end

	# DELETE /guilds/1
	# DELETE /guilds/1.json
	def destroy
		@room.destroy
		respond_to do |format|
			back_page = rooms_url
			back_page = URI(request.referer).path if params[:back]
			format.html { redirect_to back_page, notice: 'Room was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	protected

	def load_entities
		session[:room_passwords] = {} unless session[:room_passwords]
		@rooms = current_user.rooms_member
		begin
			@room = Room.find(params[:id]) if params[:id]
		rescue => e
			redirect_to rooms_path, :alert => "Room not found" and return
		end
	end

	def room_params
		params.require(:room).permit(:name, :privacy, :password)
	end

	def check_member
		redirect_to rooms_path, :alert => "You don't have permission to enter in this room" and return if @room.members.include?(current_user) == false && @room.privacy == "private"
	end

	def is_owner
		redirect_to @room, :alert => "Missing permission" and return unless @room.owner == current_user or current_user.staff
	end
end
