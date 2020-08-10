class UserController < ApplicationController
	def index
		@users = User.all.order(:nickname)
	end
	def show
		@user = User.find(params[:id])
	end
	def edit
		@user = User.find(params[:id])
		redirect_to @user unless @user.id == current_user.id
	end
	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def user_params
			params.require(:user).permit(:nickname, :profile_pic)
		end
end
