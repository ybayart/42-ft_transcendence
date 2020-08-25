class NotificationsChannel < ApplicationCable::Channel
  def subscribed
  	stream_for current_user
    # stream_from "notifications_channel"
  end

  def send_notif(data)
  	to_user = User.find_by(nickname: data["to"]);
  	if data["type"] == "play"
  		message = data["from"] + " invited you to play"
  	end
  	Notification.create(user: to_user, message: message);
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
