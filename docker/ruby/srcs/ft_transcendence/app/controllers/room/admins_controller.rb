class Room::AdminsController < ApplicationController
	before_action :set_room
	before_action :is_owner

	# GET /room/admins
	# GET /room/admins.json
	def index
		@room_admins = @room.admins.where.not(id: @room.owner.id)
	end

	# GET /room/admins/new
	def new
		@room_admin = RoomLinkAdmin.new
	end

	# POST /room/admins
	# POST /room/admins.json
	def create
		@room_admin = RoomLinkAdmin.new(room_admin_params)
		@room_admin.room = @room

		respond_to do |format|
			if @room_admin.save
				back_page = room_admins_url
				back_page = URI(request.referer).path if params[:back]
				format.html { redirect_to back_page, notice: 'Admin was successfully created.' }
			else
				format.html { render :new }
				format.json { render json: @room_admin.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /room/admins/1
	# DELETE /room/admins/1.json
	def destroy
		@room.admins.destroy(params[:id])
		respond_to do |format|
			back_page = room_admins_url
			back_page = URI(request.referer).path if params[:back]
			format.html { redirect_to back_page, notice: 'Admin was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def set_room
			@room = Room.find(params[:room_id])
		end

		def is_owner
			redirect_to @room, :alert => "Missing permission" and return unless @room.owner == current_user or current_user.staff
		end

		# Only allow a list of trusted parameters through.
		def room_admin_params
			params.require(:room_admin).permit(:user_id)
		end
end
