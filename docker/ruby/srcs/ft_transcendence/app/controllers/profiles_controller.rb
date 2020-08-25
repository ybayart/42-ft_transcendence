class ProfilesController < ApplicationController
	before_action :set_profile, only: [:show, :edit, :update]
	before_action :is_mine, only: [:edit, :update]
	before_action :need_otp, only: [:otp, :otppost]

	def index
		@profiles = User.all.order("nickname ASC")
	end

	def otp
		@profile = current_user
	end

	def otppost
		if current_user.current_otp == params[:otp_code]
			current_user.update(otp_accepted: true)
			redirect_to root_path, :notice => "OTP Code accepted"
		else
			redirect_to otp_profiles_path, :alert => "Invalid OPT Code"
		end
	end

	def friends
		@profiles = current_user.friends
	end

	def show
	end

	def edit
		unless @profile.otp_required_for_login == true
			@profile.otp_secret = User.generate_otp_secret
			@profile.save!
			issuer = 'ft_transcendence'
			label = "#{issuer}:#{@profile.email}"

			uri = @profile.otp_provisioning_uri(label, issuer: issuer)
			@svg_otp = RQRCode::QRCode.new(uri).as_svg(
					offset: 0,
					color: '000',
					shape_rendering: 'crispEdges',
					module_size: 6,
					standalone: true
				)
		end
	end

	def update
		params[:profile][:otp_required_for_login] = true if (@profile.otp_required_for_login and params[:profile][:otp_required_for_login] == true) or (params[:otp_code] and @profile.current_otp == params[:otp_code])
		if @profile.update(profile_params)
			redirect_to profile_path(@profile)
		else
			render 'edit'
		end
	end

	private
		def profile_params
			params.require(:profile).permit(:nickname, :profile_pic, :otp_required_for_login)
		end

		def set_profile
			@profile = User.find(params[:id])
		end

		def is_mine
			redirect_to profile_path(@profile), :alert => "It's not you :)" and return unless @profile == current_user
		end

		def need_otp
			redirect_to profile_path(current_user), :alert => "OTP already accepted" and return if current_user.otp_accepted == true
		end
end
