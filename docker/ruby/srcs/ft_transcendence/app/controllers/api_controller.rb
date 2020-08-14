class ApiController < ApplicationController
	respond_to :json

	def room_index
		@rooms = current_user.rooms_member
		respond_with(@rooms)
	end
end
