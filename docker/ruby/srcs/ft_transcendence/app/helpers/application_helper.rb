module ApplicationHelper
	def create_alert(message)
		raw("<div name='toast-alert' class='toast' role='alert' aria-live='assertive' aria-atomic='true' data-delay='10000'>
			<div class='toast-body'>
				" + message + "
			</div>
		</div>")
	end

	def room_rebalance_rights(room)
		room.admins << room.owner unless room.admins.include?(room.owner)
		room.admins.each do |user|
			room.members << user unless room.members.include?(user)
		end
	end

	def guild_rebalance_rights(guild)
		guild.officers << guild.owner unless guild.officers.include?(guild.owner)
		guild.officers.each do |user|
			guild.members << user unless guild.members.include?(user)
		end
	end
end
