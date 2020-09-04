class DmMessagesController < ApplicationController
	before_action :load_entities

	def create
		@dm_message = DmMessage.create(user: current_user, dm: @dm, message: params.dig(:dm_message, :message))
		unless @dm_message.errors.any?
			@dm_message = @dm_message.as_json
			@dm_message[:pic] = url_for(current_user.profile_pic)
			@dm_message[:date] = @dm_message['updated_at'].in_time_zone('Europe/Paris').strftime("%F %T")
			output = {"type": "message", "content": @dm_message}
			UserChannel.broadcast_to @dm.user1, output
			UserChannel.broadcast_to @dm.user2, output unless @dm.user1 == @dm.user2
		else
			errors = @dm_message.errors.full_messages
			@dm_message = @room_message.as_json
			@dm_message[:errors] = errors
		end
	end

	protected
		def load_entities
			@dm = Dm.find(params.dig(:dm_message, :dm_id))
		end
end
