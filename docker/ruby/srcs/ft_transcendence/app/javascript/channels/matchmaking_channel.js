import consumer from "./consumer"
import notif from "./notifications_channel"
import interval_matchmaking from "./notifications_channel"

var matchmaking;

export default matchmaking = consumer.subscriptions.create("MatchmakingChannel", {
	connected() {
		console.log("connected matchmaking");
	},

	disconnected() {
		console.log("disconnected matchmaking");
	},

	received(data) {
		$("#alert-text").html("");
		clearInterval(interval_matchmaking);
		Turbolinks.visit("/game/" + data.game_id);
	}
});

document.addEventListener('turbolinks:load', () => {
	$("#play_matchmaking").click(function() {
		matchmaking.perform('register_to_queue');
		notif.perform('send_notif', {
			type: "play_matchmaking"
		});
	});
});
