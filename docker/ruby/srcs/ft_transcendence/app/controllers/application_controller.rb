class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :check_nickname

	private
		def check_nickname
			if user_signed_in? && (controller_path != "profiles" || (action_name != "edit" && action_name != "update"))
				redirect_to edit_profile_path(current_user), :alert => "You need to pick a nickname" unless current_user.nickname
			end
		end
end
