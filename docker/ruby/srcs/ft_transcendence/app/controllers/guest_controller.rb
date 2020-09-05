class GuestController < ApplicationController
	skip_before_action :authenticate_user!, :only => [:login]
	def login
		$id = rand(1..9999)
		$login = "guest_#{$id.to_s.rjust(4, "0")}"
		if User.exists?(login: $login)
			$user = User.find(login: $login)
		else
			$user = User.new_guest($login)
		end
		sign_in_and_redirect $user, :event => :authentication
	end

end
