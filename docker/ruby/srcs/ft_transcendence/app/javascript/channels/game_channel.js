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

		var sub = consumer.subscriptions.create({
			channel: "GameChannel",
			game: $('.GameInfo').attr("value")
		}, {
			connected() {
				// PADDLE
				document.addEventListener('keypress', logKey);
				function logKey(e)
				{
          console.log(e.key);
					if (e.key == 'w')
						sub.perform('paddle_up', {});  
					if (e.key == 's')
						sub.perform('paddle_down', {});  
          if (e.key == ' ')
            sub.perform('throw_ball', {});
				}

				//REQUEST UPDATE
				setInterval(function() {
					sub.send({});
				}, 40);
			},

			disconnected() {

			},

			received(data) {
				if (data.winner)
				{
          console.log(data.winner);
					$("#game_status").html(data.winner + " wins");
					sub.perform('end', {});
				}
				else
				{
					$("#game_status").html(data.status);
					$("#p1_pts").html(data.player1_pts);
					$("#p2_pts").html(data.player2_pts);
					ctx.fillStyle = "blue";
					ctx.clearRect(0, 0, canvas.width, canvas.height);
					ctx.fillRect(0, 0, canvas.width, canvas.height);
					ctx.fillStyle = "black";
					printBall(data.ballPosX, data.ballPosY, data.ballRadius);
					printPaddle(data.paddle1PosX, data.paddle1PosY, data.paddle1Width, data.paddle1Height);
					printPaddle(data.paddle2PosX, data.paddle2PosY, data.paddle2Width, data.paddle2Height);
				}
			}
		});
	}
});
