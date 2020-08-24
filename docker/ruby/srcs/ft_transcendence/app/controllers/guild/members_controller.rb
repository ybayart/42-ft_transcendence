class Guild::MembersController < ApplicationController
	before_action :set_guild
	before_action :is_admin

	# GET /guild/members
	# GET /guild/members.json
	def index
		@guild_members = @guild.members - @guild.admins
	end

	# GET /guild/members/new
	def new
		@guild_member = GuildLinkMember.new
	end

	# POST /guild/members
	# POST /guild/members.json
	def create
		@guild_member = GuildLinkMember.new(guild_member_params)
		@guild_member.guild = @guild

		respond_to do |format|
			if @guild_member.save
				format.html { redirect_to guild_members_url, notice: 'Member was successfully created.' }
			else
				format.html { render :new }
				format.json { render json: @guild_member.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /guild/members/1
	# DELETE /guild/members/1.json
	def destroy
		@guild.members.destroy(params[:id])
		respond_to do |format|
			format.html { redirect_to guild_members_url, notice: 'Member was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def set_guild
			@guild = Guild.find(params[:guild_id])
		end

		def is_admin
			redirect_to @guild, :alert => "Missing permission" and return unless @guild.admins.include?(current_user)
		end

		# Only allow a list of trusted parameters through.
		def guild_member_params
			params.require(:guild_member).permit(:user_id)
		end
end

