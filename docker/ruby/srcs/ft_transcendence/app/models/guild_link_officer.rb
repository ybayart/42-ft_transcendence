class GuildLinkOfficer < ApplicationRecord
	belongs_to :guild
	belongs_to :user
end
