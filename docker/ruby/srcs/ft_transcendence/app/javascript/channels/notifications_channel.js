import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
	var button = $("#game_invite");
	var sub = consumer.subscriptions.create("NotificationsChannel", {
	  connected() {
	  	if (button)
	  	{
		  	button.click(function() {
		  		var to_nickname = $("#nickname").html();
		  		var from_nickname = $("#nav-nickname").attr("usernickname");
					sub.perform('send_notif', { type: "play", to: to_nickname, from: from_nickname });
					button.prop('disabled', true);
					setTimeout(function(){ button.prop('disabled', false); }, 5000);
				});
			}
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	  	console.log(data);
	    // Called when there's incoming data on the websocket for this channel
	  }
	});
});