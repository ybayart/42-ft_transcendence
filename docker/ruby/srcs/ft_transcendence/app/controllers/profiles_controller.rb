class ProfilesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_profile, only: [:show, :edit, :update]
	before_action :is_mine, only: [:edit, :update]

	def index
		@profiles = User.all.order("nickname ASC")
	end

	def friends
		@profiles = current_user.friends
	end
	def show
	end
	def edit
	end
	def update
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

		def set_profile
			@profile = User.find(params[:id])
		end

		def is_mine
			redirect_to profile_path(@profile), :alert => "It's not you :)" and return unless @profile == current_user
		end
end
