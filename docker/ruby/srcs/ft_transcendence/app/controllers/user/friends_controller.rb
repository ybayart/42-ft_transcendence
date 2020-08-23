class User::FriendsController < ApplicationController
	before_action :set_user
	before_action :is_mine

	# GET /user/friends
	# GET /user/friends.json
	def index
		@user_friends = @user.friends
	end

	# GET /user/friends/new
	def new
		@user_friend = Friendship.new
	end

	# POST /user/friends
	# POST /user/friends.json
	def create
		@user_friend = Friendship.new(user_friend_params)
		@user_friend.friend_a = current_user

		respond_to do |format|
			if @user_friend.save
				format.html { redirect_to user_friends_url, notice: 'Friend was successfully created.' }
			else
				format.html { render :new }
				format.json { render json: @user_friend.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /user/friends/1
	# DELETE /user/friends/1.json
	def destroy
		@user.friends.destroy(params[:id])
		respond_to do |format|
			format.html { redirect_to user_friends_url, notice: 'Friend was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_user
			@user = User.find(params[:user_id])
		end

		def is_mine
			redirect_to @user, :alert => "It's not you :)" and return unless @user == current_user
		end

		# Only allow a list of trusted parameters through.
		def user_friend_params
			params.require(:friendship).permit(:friend_b_id)
		end
end
