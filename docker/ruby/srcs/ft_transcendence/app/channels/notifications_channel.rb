class NotificationsChannel < ApplicationCable::Channel

	def subscribed
		stream_for current_user
		# stream_from "notifications_channel"
	end

	def send_notif(data)
		$from_user = current_user
		if data["type"] == "play_casual"
			if GameLogic.check_rules(data)
				$to_user = User.find_by(nickname: data["to"])
				if $from_user != $to_user
					$game = Game.create(player1: $from_user, player2: $to_user, status: "waiting", mode: "casual", creator_id: $from_user.id, max_points: data["max_points"].to_i)
					@gameLogic = GameLogic.create($game.id, data["canvas"]["width"].to_i, data["canvas"]["height"].to_i, data["ball"]["radius"].to_i)
					$message = $from_user.nickname + " invited you to play."
					Notification.create(user: $to_user, message: $message)
					NotificationsChannel.broadcast_to($to_user, {
						type: "invitation",
						game:
						{
							id: $game.id
						},
						message: $message
					})
					NotificationsChannel.broadcast_to($from_user, {
						type: "redirect",
						game:
						{
							id: $game.id
						}
					})
				end
			end
		end
		if data["type"] == "play_matchmaking"
			$message = "Waiting for matchmaking"
			NotificationsChannel.broadcast_to($from_user, {
				type: "in_queue",
				message: $message
			});
		end
	end

	def unsubscribed
	# Any cleanup needed when channel is unsubscribed
	end

end
