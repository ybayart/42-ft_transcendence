import consumer from "./consumer"
import matchmaking from "./matchmaking_channel"

var alert;
var timer_queue;
var interval_matchmaking;

var add_notif = function(text)
{
	let new_one = $(".alert").last().clone();
	$("#alerts-div").append(new_one);
	new_one.find("#alert-text").html(text);
	return (new_one);	
}

var clear_matchmaking = function()
{
	matchmaking.perform("unsubscribe_queue");
	clearInterval(interval_matchmaking);
	clear_matchmaking = null;
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
			add_notif(data.message + " <a href='/game/" + data.game.id+ "'>Click to join</a>").show();
		else if (data.type && data.type == "in_queue" && !clear_matchmaking)
		{
			$("#alert-text").html(data.message + " - ");
			timer_queue = $("<span id='time_queue'>00:00</span>");
			$("#alert-text").append(timer_queue);
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
				alert = $("#alert-text");
			}, 1000);
			$(".alert .close").click(clear_matchmaking);
			$(".alert").show();
		}
		alert = $("#alert-text");
	}
});

document.addEventListener('turbolinks:load', () => {
	if (alert)
		$("#alert-text").html(alert.html());
	else
	{
		alert = $("#alert-text");
		alert.html("");
	}
	if (alert.html().length != 0)
		$(".alert").show();
	if (clear_matchmaking)
		$(".alert .close").click(clear_matchmaking);
	var button = $("#game_invite");
	if (button)
	{
  		button.click(function() {
  			var to_nickname = $("#nickname").html();
  			var from_nickname = $("#nav-nickname").attr("usernickname");
			notif.perform('send_notif', {
				type: "play_casual",
				to: to_nickname
			});
		});
	}
});

export { interval_matchmaking, notif };

