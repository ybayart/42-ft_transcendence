class UserController < ApplicationController
	def index
		@user = current_user
	end
	def edit
		@user = current_user
	end
end
