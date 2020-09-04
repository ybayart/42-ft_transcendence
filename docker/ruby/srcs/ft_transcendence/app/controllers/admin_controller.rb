class AdminController < ApplicationController
	before_action :is_admin

	def is_admin
		redirect_to root_path, :alert => "Missing permission" and return unless current_user.staff
	end
end
