import consumer from "./consumer"
import matchmaking from "./matchmaking_channel"

var alert;
var timer_queue;
var interval_matchmaking;
var clear_matchmaking;
var notif;

export { interval_matchmaking };

export default notif = consumer.subscriptions.create("NotificationsChannel", {

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
		{
			$("#alert-text").html(data.message + " <a href='/game/" + data.game.id+ "'>Click to join</a>");
			$(".alert").show();
		}
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
			clear_matchmaking = function ()
			{
				matchmaking.perform("unsubscribe_queue");
				clearInterval(interval_matchmaking);
				var alert_parent = alert.parent().clone();
				alert_parent.insertAfter("#toast-container");
				alert = alert_parent.children("#alert-text");
				alert.html("");
				alert_parent.hide();
				clear_matchmaking = null;
			}
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
