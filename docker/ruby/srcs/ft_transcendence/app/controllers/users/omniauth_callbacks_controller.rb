class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def marvin
		@user = User.from_omniauth(request.env["omniauth.auth"])

		if @user.persisted?
			@user.update(otp_accepted: @user.otp_required_for_login != true)
			sign_in_and_redirect @user, :event => :authentication
			set_flash_message(:notice, :success, :kind => "42") if is_navigational_format?
		else
			session["devise.marvin_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end
end
