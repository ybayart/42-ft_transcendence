class GuildInvitMember < ApplicationRecord
	belongs_to :guild
	belongs_to :user
	belongs_to :by, class_name: 'User', inverse_of: :guild_invites
end
