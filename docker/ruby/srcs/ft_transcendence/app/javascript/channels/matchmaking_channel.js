import consumer from "./consumer"

if (window.location.href.indexOf("matchmaking") != -1)
{
	consumer.subscriptions.create("MatchmakingChannel", {
		connected() {
			console.log("connected matchmaking");
		},

		disconnected() {
			console.log("disconnected matchmaking");
		},

		received(data) {
			console.log(data);
			window.location.href = "/game/"+data.game.id;
		}
	});
}
