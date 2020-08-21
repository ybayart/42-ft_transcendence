import consumer from "./consumer"
import Paddle from "../custom/paddle"
import Ball from "../custom/ball"

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

			var beginning_status = $("#game_status").html();
			var me = (beginning_status == "waiting") ? 0 : 1;
			var paddles = [null, null];
			var ball = null;
			var inputs_id = 0;
			var unverified_inputs = [];

			function resetCanvas()
			{
				ctx.clearRect(0, 0, canvas.width, canvas.height);
				ctx.fillStyle = background_color;
				ctx.fillRect(0, 0, canvas.width, canvas.height);
			}

			function eraseBall(x, y, radius) {
				ctx.fillStyle = background_color;
				ctx.fillRect(x - (radius + 1), y - (radius + 1), (radius + 2) * 2, (radius + 2) * 2);
			}

			function printBall(ball) {
				ctx.beginPath();
				ctx.fillStyle = ball_color;
				ctx.arc(ball.posX, ball.posY, ball.radius, 0, 2 * Math.PI, false);
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
				{
					sub.perform('input', { type: "paddle_up", id: inputs_id });
					unverified_inputs.push(inputs_id);
					inputs_id++;
					// if (paddles[me])
					// 	paddles[me].goUp()
				}
				else if (e.key == 's')
				{
					sub.perform('input', { type: "paddle_down", id: inputs_id });
					unverified_inputs.push(inputs_id);
					inputs_id++;
					// if (paddles[me])
					// 	paddles[me].goDown()
				}
				else if (e.key == ' ')
				{
					sub.perform('throw_ball', { id: inputs_id });
					inputs_id++;
				}
				// if ((e.key == 'w' || e.key == 's') && paddles[me])
				// {
				// 	resetCanvas()
				// 	printPaddle(paddles[me]);
				// }
			}

			resetCanvas();

			var sub = consumer.subscriptions.create({
				channel: "GameChannel",
				game: $('.GameInfo').attr("value")
				}, {
				connected() {
					document.addEventListener('keypress', logKey);
				},

				disconnected() {

				},

				received(data) {
					if (data.status == "waiting")
					{
						$("#game_status").html(data.status);
					}
					else if (data.status == "running")
					{
						$("#game_status").html(data.status);
						$("#p1_pts").html(data.scores.player1);
						$("#p2_pts").html(data.scores.player2);

						if (ball == null)
							ball = new Ball(data.ball)
						if (paddles[0] == null)
							paddles[0] = new Paddle(data.paddles[0])
						if (paddles[1] == null)
							paddles[1] = new Paddle(data.paddles[1])

						data.inputs[me].forEach(function(server_id) {
							unverified_inputs.forEach(function(client_id, index) {
								if (server_id == client_id)
									unverified_inputs.splice(index, 1);
							});
						});

						console.log(unverified_inputs);

						resetCanvas();
						printBall(data.ball);
						printPaddle(data.paddles[0]);
						printPaddle(data.paddles[1]);

					}
					else if (data.status == "finished")
					{
						$("#game_status").html(data.winner + " wins");
						resetCanvas();
						sub.unsubscribe()
						document.removeEventListener('keypress', logKey);
					}
					// if (data.winner)
					// {
					// 	console.log(data.winner);
					// 	$("#game_status").html(data.winner + " wins");
					// 	sub.perform('update_game', {});
					// 	clearInterval(request_update);
					// 	sub.unsubscribe()
					// 	document.removeEventListener('keypress', logKey);
					// }
					// else
					// {
					// 	if (paddles[0] == null)
					// 		paddles[0] = new Paddle(data.paddles[0]);
					// 	if (paddles[1] == null)
					// 		paddles[1] = new Paddle(data.paddles[1]);
					// 	$("#game_status").html(data.status);
					// 	$("#p1_pts").html(data.scores.player1);
					// 	$("#p2_pts").html(data.scores.player2);
					// 	if (ball == null)
					// 		ball = data.ball;
					// 	eraseBall(ball.posX, ball.posY, ball.radius);
					// 	ball = data.ball;
					// 	printBall(data.ball.posX, data.ball.posY, data.ball.radius);
					// 	erasePaddle(paddles[0]);
					// 	paddles[0].posY = data.paddles[0].posY;
					// 	printPaddle(paddles[0]);
					// 	erasePaddle(paddles[1]);
					// 	paddles[1].posY = data.paddles[1].posY;
					// 	printPaddle(paddles[1]);
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
					// }
				}
			});
		}
	});
});
