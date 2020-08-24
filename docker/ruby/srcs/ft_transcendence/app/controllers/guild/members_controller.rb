class Guild::MembersController < ApplicationController
	before_action :set_guild
	before_action :is_admin

	# GET /guild/members
	# GET /guild/members.json
	def index
		@guild_members = @guild.members - @guild.officers
	end

	# DELETE /guild/members/1
	# DELETE /guild/members/1.json
	def destroy
		@guild.members.find(params[:id]).update(guild: nil)
		respond_to do |format|
			format.html { redirect_to guild_members_url, notice: 'Member invitation was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def set_guild
			@guild = Guild.find(params[:guild_id])
		end

		def is_admin
			redirect_to @guild, :alert => "Missing permission" and return unless @guild.officers.include?(current_user)
		end

		# Only allow a list of trusted parameters through.
		def guild_member_params
			params.require(:guild_member).permit(:user_id)
		end
end

