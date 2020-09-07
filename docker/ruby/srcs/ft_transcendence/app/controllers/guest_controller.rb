class GuestController < ApplicationController
	skip_before_action :authenticate_user!, :only => [:login]
	def login
		valid = rand(1..9999)
		vallogin = "guest_#{valid.to_s.rjust(4, "0")}"
		if User.exists?(login: vallogin)
			valuser = User.find(login: vallogin)
		else
			valuser = User.new_guest(vallogin)
		end
		sign_in_and_redirect valuser, :event => :authentication
	end

end
