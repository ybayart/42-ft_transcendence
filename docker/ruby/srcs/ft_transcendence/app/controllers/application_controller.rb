class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :check
	before_action :check_war_state

	private
		def check
			if user_signed_in? && check_sign_out && (controller_path != "profiles" || (action_name != "otp" && action_name != "otppost"))
				redirect_to otp_profiles_path, :alert => "Enter your otp code" and return unless current_user.otp_accepted == true
			end

			if user_signed_in? && check_sign_out && (controller_path != "profiles" || (action_name != "edit" && action_name != "update")) && current_user.otp_accepted == true
				redirect_to edit_profile_path(current_user), :alert => "You need to pick a nickname" unless current_user.nickname
			end
		end

		def check_sign_out
			return controller_path != "devise/sessions" || action_name != "destroy"
		end

		def check_war_state
			War.where(state: ["waiting for war times", "declared"]).each do |war|
				war.update(state: "aborted") if war.start_at.past?
			end
			War.where(state: ["pending"]).each do |war|
				war.update(state: "active") if war.start_at.past?
			end
			War.where(state: ["active"]).each do |war|
				war.update(state: "ended") if war.end_at.past?
			end
		end
end
