class Profile::FriendsController < ApplicationController
	before_action :set_profile
	before_action :is_mine

	# GET /profile/friends
	# GET /profile/friends.json
	def index
		@profile_friends = @profile.friends
	end

	# GET /profile/friends/new
	def new
		@profile_friend = Friendship.new
	end

	# POST /profile/friends
	# POST /profile/friends.json
	def create
		@profile_friend = Friendship.new(profile_friend_params)
		@profile_friend.friend_a = current_user

		respond_to do |format|
			if @profile_friend.save
				format.html { redirect_to profile_friends_url, notice: 'Friend was successfully created.' }
			else
				format.html { render :new }
				format.json { render json: @profile_friend.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /profile/friends/1
	# DELETE /profile/friends/1.json
	def destroy
		@profile.friends.destroy(params[:id])
		respond_to do |format|
			format.html { redirect_to profile_friends_url, notice: 'Friend was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_profile
			@profile = User.find(params[:profile_id])
		end

		def is_mine
			redirect_to @profile, :alert => "It's not you :)" and return unless @profile == current_user
		end

		# Only allow a list of trusted parameters through.
		def profile_friend_params
			params.require(:friendship).permit(:friend_b_id)
		end
end
