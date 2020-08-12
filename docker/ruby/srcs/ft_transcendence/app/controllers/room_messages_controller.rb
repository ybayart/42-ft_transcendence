class RoomMessagesController < ApplicationController
	before_action :load_entities

	def create
		@room_message = RoomMessage.create(user: current_user, room: @room, message: params.dig(:room_message, :message))
		unless @room_message.errors.any?
			@room_message = @room_message.as_json
			@room_message[:pic] = url_for(current_user.profile_pic)
			@room_message[:date] = @room_message['updated_at'].in_time_zone('Europe/Paris').strftime("%F %T")
			RoomChannel.broadcast_to @room, @room_message
		else
			errors = @room_message.errors.full_messages
			@room_message = @room_message.as_json
			@room_message[:errors] = errors
		end
	end

	protected

	def load_entities
		@room = Room.find params.dig(:room_message, :room_id)
	end
end
