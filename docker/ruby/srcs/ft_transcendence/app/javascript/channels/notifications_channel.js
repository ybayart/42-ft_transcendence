import consumer from "./consumer"
import matchmaking from "./matchmaking_channel"

var timer_queue;
var interval_matchmaking;

var add_notif = function(text, new_id)
{
	let new_one = $(".alert").last().clone();
	new_one.attr("id", new_id);
	$("#alerts-div").append(new_one);
	new_one.find("#alert-text").html(text);
	return (new_one);	
}

var clear_matchmaking = function()
{
	matchmaking.perform("unsubscribe_queue");
	clearInterval(interval_matchmaking);
};

var notif = consumer.subscriptions.create("NotificationsChannel", {

	connected() {
	  	console.log("connected to notif");
	},

	disconnected() {
	},

	received(data) {
		console.log(data);
		if (data.type && data.type == "redirect")
			Turbolinks.visit("/game/" + data.game.id);
		else if (data.type && data.type == "invitation")
			add_notif(data.message + " <a href='/game/" + data.game.id + "'>Click to join</a>").show();
		else if (data.type && data.type == "in_queue")
		{
			var text = data.message + " - " + "<span id='time_queue'>00:00</span>";
			var new_notif = add_notif(text, "matchmaking-alert");
			var timer_start = Date.now();
			interval_matchmaking = setInterval(function() {
				console.log("interval");
				var res = (Date.now() - timer_start) / 1000;
				var minutes = Math.floor(res / 60) % 60;
				var seconds = Math.floor(res % 60);
				if (minutes < 10)
					minutes = "0" + minutes;
				if (seconds < 10)
					seconds = "0" + seconds;
				$("#time_queue").html(minutes+":"+seconds);
				alert = new_notif.find("#alert-text");
			}, 1000);
			new_notif.find(".close").click(clear_matchmaking);
			new_notif.show();
		}
	}
});

document.addEventListener('turbolinks:load', () => {
	var button = $("#game_invite");
	if (button)
	{
		button.click(function() {
			var to_nickname = $("#nickname").html();
			notif.perform('send_notif', {
				type: "play_casual",
				to: to_nickname
			});
		});
	}
});

export { interval_matchmaking, notif };

