import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
	var button = $("#game_invite");
	var sub = consumer.subscriptions.create("NotificationsChannel", {
	  connected() {
	  	console.log("connected to notif")
	  	if (button)
	  	{
		  	button.click(function() {
		  		var to_nickname = $("#nickname").html();
		  		var from_nickname = $("#nav-nickname").attr("usernickname");
					sub.perform('send_notif', { type: "play_casual", to: to_nickname, from: from_nickname });
				});
			}
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	  	console.log(data);
	  	if (data.game_id && !data.from)
				Turbolinks.visit("/game/" + data.game_id);
			else if (data.game_id && data.from)
			{
				$("#alert-text").html(data.from + " invited you to play. " + " <a href='/game/" + data.game_id + "'>Click to join</a>");
				$(".alert").show();
			}
	    // Called when there's incoming data on the websocket for this channel
	  }
	});
});