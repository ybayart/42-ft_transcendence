class NotificationsChannel < ApplicationCable::Channel
  def subscribed
  	stream_for current_user
    # stream_from "notifications_channel"
  end

  def send_notif(data)
  	to_user = User.find_by(nickname: data["to"]);
  	if (data["from"])
	  	from_user = User.find_by(nickname: data["from"]);
	  end
  	if data["type"] == "play_casual"
  		game = Game.create(player1: from_user, player2: to_user, status: "waiting")
  		message = data["from"] + " invited you to play"
  	end
  	Notification.create(user: to_user, message: message);
  	NotificationsChannel.broadcast_to(to_user, game_id: game.id, from: from_user.nickname);
  	NotificationsChannel.broadcast_to(from_user, game_id: game.id);
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
