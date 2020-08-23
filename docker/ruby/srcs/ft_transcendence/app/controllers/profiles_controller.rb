class ProfilesController < ApplicationController
	before_action :authenticate_user!

	def index
		@profiles = User.all.order("nickname ASC")
	end

	def friends
		@profiles = current_user.friends
	end
	def show
		@profile = User.find(params[:id])
	end
	def edit
		@profile = User.find(params[:id])
		redirect_to @profile unless @profile.id == current_user.id
	end
	def update
		@profile = User.find(params[:id])
		if @profile.update(profile_params)
			redirect_to profile_path(@profile)
		else
			render 'edit'
		end
	end

	private
		def profile_params
			params.require(:profile).permit(:nickname, :profile_pic)
		end
end
