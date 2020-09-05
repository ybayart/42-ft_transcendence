class GuildInvitMember < ApplicationRecord
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
	belongs_to :guild
	belongs_to :user
	belongs_to :by, class_name: 'User', inverse_of: :send_invites

	validates :state,
			presence: true,
			inclusion: {
				in: %w(waiting rejected accepted),
				message: "%{value} is not a valid state"}

	after_create :notif

	def notif
		Notification.create(user: self.user, title: 'Guild invitation', message: "#{link_to self.by.nickname, profile_path(self.by)} invited you in his guild (<b>#{link_to self.guild.name, guild_path(self.guild)}</b>)<br>You can asnwer #{link_to 'here', invitations_guilds_path}")
	end
end
