class NotificationsChannel < ApplicationCable::Channel
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper

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
					$game_rules = GameRule.create(canvas_width: data["canvas"]["width"].to_i, canvas_height: data["canvas"]["height"].to_i, ball_radius: data["ball"]["radius"].to_i, max_points: data["max_points"].to_i)
					$game = Game.create(player1: $from_user, player2: $to_user, status: "waiting", mode: "casual", game_rules: $game_rules)
					$message = $from_user.nickname + " invited you to play."
					NotificationsChannel.broadcast_to($to_user, {
						type: "invitation",
						game:
						{
							id: $game.id
						},
						message: $message
					})
#					Notification.create(use: $to_user, title: 'Invitation to play', message: "#{<%= link_to $from_user.nickname, profile_path($from_user)} invited you to play a game!<br>Join #{link_to 'here', game_path($game)}")
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
