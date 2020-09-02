class Admin::RoomsController < AdminController
	before_action :set_admin_room, only: [:show, :edit, :update, :destroy]

	# GET /admin/rooms
	# GET /admin/rooms.json
	def index
		@rooms = Room.all
	end

	# GET /admin/rooms/1
	# GET /admin/rooms/1.json
	def show
		@admins = @room.admins.order("nickname ASC") - [@room.owner]
		@members = @room.members.order("nickname ASC") - @room.admins
	end

	# DELETE /admin/rooms/1
	# DELETE /admin/rooms/1.json
	def destroy
		@admin_room.destroy
		respond_to do |format|
			format.html { redirect_to admin_rooms_url, notice: 'Room was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_admin_room
			begin
				@room = Room.find(params[:id])
			rescue
				redirect_to admin_rooms_path, :alert => "Room not found" and return
			end
		end
end
