import consumer from "./consumer"
import Paddle from "../custom/paddle"

document.addEventListener('turbolinks:load', () => {
	$(document).ready(function () {
		var canvas = document.querySelector('.myCanvas');
		if (canvas)
		{
			canvas.width = 600;
			canvas.height = 600;

			var ctx = canvas.getContext('2d');
			var background_color = "blue";
			var paddle_color = "black";
			var ball_color = "black";

			function resetCanvas()
			{
				ctx.clearRect(0, 0, canvas.width, canvas.height);
				ctx.fillStyle = background_color;
				ctx.fillRect(0, 0, canvas.width, canvas.height);
			}

			resetCanvas();

			function eraseBall(x, y, radius) {
				ctx.fillStyle = background_color;
				ctx.fillRect(x - (radius + 1), y - (radius + 1), (radius + 2) * 2, (radius + 2) * 2);
			}

			function printBall(x, y, radius) {
				ctx.beginPath();
				ctx.fillStyle = ball_color;
				ctx.arc(x, y, radius, 0, 2 * Math.PI, false);
				ctx.fill();
			}

			function erasePaddle(paddle) {
				ctx.fillStyle = background_color;
				ctx.fillRect(paddle.posX, paddle.posY - 5, paddle.width, paddle.height + 10);
			}

			function printPaddle(paddle) {
				ctx.fillStyle = paddle_color;
				ctx.fillRect(paddle.posX, paddle.posY, paddle.width, paddle.height);
			}

			function logKey(e) {
				if (e.key == 'w')
					sub.perform('paddle_up', {});
				else if (e.key == 's')
					sub.perform('paddle_down', {});
				else if (e.key == ' ')
					sub.perform('throw_ball', {});
			}

			var request_update;
			var refresh_ms = 40;
			var paddles = [null, null];
			var ball;

			/*
			function smooth_paddle_slide(nb, data, callback) {
				console.log("data "+ data.posY);
				console.log("paddles "+paddles[nb].posY);
				var diff = data.posY - paddles[nb].posY;
				var nb_times = (refresh_ms / 10) - 2;
				var steps;
				if (diff == 0)
				{
					erasePaddle(paddles[nb]);
					printPaddle(paddles[nb]);
					callback();
					return ;
				}
				else if (diff > 0)
					steps = Math.floor(diff / nb_times);
				else
					steps = Math.ceil(diff / nb_times);
				var rest = diff % nb_times;
				async function printer(){
					nb_times--;
					if (nb_times == 0)
					{
						erasePaddle(paddles[nb]);
						paddles[nb].posY += rest;
						printPaddle(paddles[nb]);
						callback();
						return ;
					}
					else
					{
						erasePaddle(paddles[nb]);
						paddles[nb].posY += steps;
						diff -= steps;
						printPaddle(paddles[nb]);
						setTimeout(printer, 10);
					}
				}
				setTimeout(printer, 10);
			}

			var queue = [null, null];
			queue[0] = [];
			queue[1] = [];

			function	callback_queue0()
			{
				if (queue[0].length > 1)
				{
					queue[0].shitf();
					queue[0][0]();
				}
				else if (queue[0].length > 0)
					queue[0].shitf();
			}

			function	callback_queue1()
			{
				if (queue[1].length > 1)
				{
					queue[1].shift();
					queue[1][0]();
				}
				else if (queue[1].length > 0)
					queue[1].shift();
			}*/

			var sub = consumer.subscriptions.create({
				channel: "GameChannel",
				game: $('.GameInfo').attr("value")
			}, {
				connected() {
					document.addEventListener('keypress', logKey);

					request_update = setInterval(function() {
						sub.send({});
					}, refresh_ms);
				},

				disconnected() {

				},

				received(data) {
					if (data.winner)
					{
						console.log(data.winner);
						$("#game_status").html(data.winner + " wins");
						sub.perform('update_game', {});
						clearInterval(request_update);
						sub.unsubscribe()
						document.removeEventListener('keypress', logKey);
					}
					else
					{
						if (paddles[0] == null)
							paddles[0] = new Paddle(data.paddles[0]);
						if (paddles[1] == null)
							paddles[1] = new Paddle(data.paddles[1]);
						$("#game_status").html(data.status);
						$("#p1_pts").html(data.scores.player1);
						$("#p2_pts").html(data.scores.player2);
						if (ball == null)
							ball = data.ball;
						eraseBall(ball.posX, ball.posY, ball.radius);
						ball = data.ball;
						printBall(data.ball.posX, data.ball.posY, data.ball.radius);
						erasePaddle(paddles[0]);
						paddles[0].posY = data.paddles[0].posY;
						printPaddle(paddles[0]);
						erasePaddle(paddles[1]);
						paddles[1].posY = data.paddles[1].posY;
						printPaddle(paddles[1]);
						/*
						if (queue[0].length == 0)
							smooth_paddle_slide(0, data.paddles[0], callback_queue0);
						else
							queue[0].push(smooth_paddle_slide.bind(null, 0, data.paddles[0], callback_queue0));
						if (queue[1].length == 0)
							smooth_paddle_slide(1, data.paddles[1], callback_queue1);
						else
							queue[1].push(smooth_paddle_slide.bind(null, 1, data.paddles[1], callback_queue1));
							*/
					}
				}
			});
		}
	});
});
