class AdminsController < ApplicationController
	before_action :is_admin, only: [:index]

	# GET /admins
	# GET /admins.json
	def index
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def is_admin
			redirect_to root_path, :alert => "Missing permission" and return unless ["fgoulama", "lmartin", "ybayart", "yanyan"].include?(current_user.login)
		end

		# Only allow a list of trusted parameters through.
		def admin_params
			params.fetch(:admin, {})
		end
end
