class Admin::GuildsController < AdminController
	before_action :set_admin_guild, only: [:show]

	# GET /admin/guilds
	# GET /admin/guilds.json
	def index
		@guilds = Guild.all
	end

	# GET /admin/guilds/1
	# GET /admin/guilds/1.json
	def show
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_admin_guild
			begin
				@guild = Guild.find(params[:id])
			rescue
				redirect_to admin_guilds_path, :alert => "Guild not found" and return
			end
		end
end
