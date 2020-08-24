class Guild::OfficersController < ApplicationController
	before_action :set_guild
	before_action :is_owner

	# GET /guild/officers
	# GET /guild/officers.json
	def index
		@guild_officers = @guild.officers.where.not(id: @guild.owner.id)
	end

	# GET /guild/officers/new
	def new
		@guild_officer = GuildLinkOfficer.new
	end

	# POST /guild/officers
	# POST /guild/officers.json
	def create
		@guild_officer = GuildLinkOfficer.new(guild_officer_params)
		@guild_officer.guild = @guild

		respond_to do |format|
			if @guild_officer.save
				format.html { redirect_to guild_officers_url, notice: 'Officer was successfully created.' }
			else
				format.html { render :new }
				format.json { render json: @guild_officer.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /guild/officers/1
	# DELETE /guild/officers/1.json
	def destroy
		@guild.officers.destroy(params[:id])
		respond_to do |format|
			format.html { redirect_to guild_officers_url, notice: 'Officer was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		def set_guild
			@guild = Guild.find(params[:guild_id])
		end

		def is_owner
			redirect_to @guild, :alert => "Missing permission" and return unless @guild.owner == current_user
		end

		# Only allow a list of trusted parameters through.
		def guild_officer_params
			params.require(:guild_officer).permit(:user_id)
		end
end
