class GuildLinkOfficer < ApplicationRecord
	belongs_to :guild
	belongs_to :user

	after_commit	:apply_modifications

	def apply_modifications
		ApplicationController.helpers.guild_rebalance_rights(self.guild)
	end
end
