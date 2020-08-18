import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
	var canvas = document.querySelector('.myCanvas');
	if (canvas)
	{
		canvas.width = 600;
		canvas.height = 600;

		var ctx = canvas.getContext('2d');
		ctx.fillStyle = "blue";
		ctx.fillRect(0, 0, canvas.width, canvas.height);
		ctx.fillStyle = "black";

		function printBall(x, y, radius)
		{	  
			ctx.beginPath();
			ctx.arc(x, y, radius, 0, 2 * Math.PI, false);
			ctx.fill();
		}

		function printPaddle(x, y, width, height)
		{
			ctx.fillRect(x, y, width, height);
		}

		function logKey(e)
		{
			if (e.key == 'w')
				sub.perform('paddle_up', {});  
			else if (e.key == 's')
				sub.perform('paddle_down', {});  
			else if (e.key == ' ')
				sub.perform('throw_ball', {});
		}

		var request_update;

		var sub = consumer.subscriptions.create({
			channel: "GameChannel",
			game: $('.GameInfo').attr("value")
		}, {
			connected() {
				document.addEventListener('keypress', logKey);

				request_update = setInterval(function() {
					sub.send({});
				}, 40);
			},

			disconnected() {

			},

			received(data) {
				if (data.winner)
				{
					$("#game_status").html(data.winner + " wins");
					sub.perform('update_game', {});
					clearInterval(request_update);
				}
				else
				{
					$("#game_status").html(data.status);
					$("#p1_pts").html(data.scores.player1);
					$("#p2_pts").html(data.scores.player2);
					ctx.fillStyle = "blue";
					ctx.clearRect(0, 0, canvas.width, canvas.height);
					ctx.fillRect(0, 0, canvas.width, canvas.height);
					ctx.fillStyle = "black";
					printBall(data.ball.posX, data.ball.posY, data.ball.radius);
					printPaddle(data.paddles[0].posX, data.paddles[0].posY, data.paddles[0].width, data.paddles[0].height);
					printPaddle(data.paddles[1].posX, data.paddles[1].posY, data.paddles[1].width, data.paddles[1].height);
				}
			}
		});
	}
});
