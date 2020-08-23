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
			

			var spectate;
			var me;
			var other;
			if (window.location.href.indexOf("test") == -1) //spec
			{
				me = 0;
				other = 1;
				spectate = true;
			}
			else
			{
				me = (beginning_status == "waiting") ? 0 : 1;
				other = me == 1 ? 0 : 1;
				spectate = false;
			}

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
				ctx.fillRect(paddle.posX, paddle.posY, paddle.width, paddle.height);
			}

			function printPaddle(paddle) {
				ctx.fillStyle = paddle_color;
				ctx.fillRect(paddle.posX, paddle.posY, paddle.width, paddle.height);
			}

			function renderWorld() {
				resetCanvas();
				printPaddle(paddles[me]);
				printPaddle(paddles[other]);
				printBall(ball);
			}

			function logKey(e) {
				if (e.key == 'w')
				{
					sub.perform('input', { type: "paddle_up", id: inputs_id });
					unverified_inputs.push({id: inputs_id, type: "up"});
					inputs_id++;
					if (paddles[me])
						paddles[me].goUp();
				}
				else if (e.key == 's')
				{
					sub.perform('input', { type: "paddle_down", id: inputs_id });
					unverified_inputs.push({id: inputs_id, type: "down"});
					inputs_id++;
					if (paddles[me])
						paddles[me].goDown();
				}
				else if (e.key == ' ')
				{
					sub.perform('throw_ball', { id: inputs_id });
					inputs_id++;
				}
			}

			var server_interval = 5;

			function interpolate(entity) {
				var render_timestamp = new Date() - (1000.0 / server_interval);

				// Find the two authoritative positions surrounding the rendering timestamp.
				var buffer = entity.position_buffer;

				// Drop older positions.
				while (buffer.length >= 2 && buffer[1][0] <= render_timestamp) {
					buffer.shift();
				}

				// Interpolate between the two surrounding authoritative positions.
				if (buffer.length >= 2 && buffer[0][0] <= render_timestamp && render_timestamp <= buffer[1][0]) {
					var x0 = buffer[0][1];
					var x1 = buffer[1][1];
					var y0 = buffer[0][2];
					var y1 = buffer[1][2];
					var t0 = buffer[0][0];
					var t1 = buffer[1][0];

					entity.posX = x0 + (x1 - x0) * (render_timestamp - t0) / (t1 - t0);
					entity.posY = y0 + (y1 - y0) * (render_timestamp - t0) / (t1 - t0);
				}
			}

			function update() {
				if (ball)
					interpolate(ball);
				if (spectate)
					interpolate(paddles[me]);
				if (paddles[other])
					interpolate(paddles[other]);
				if (ball && paddles && paddles[me] && paddles[other])
					renderWorld();
			}

			var update_interval;
			
			function setUpdateRate(update_rate) {
				clearInterval(update_interval);
				if (update_rate != 0)
					update_interval = setInterval(update, 1000 / update_rate);
			}
				
			resetCanvas();

			var sub = consumer.subscriptions.create({
				channel: "GameChannel",
				game: $('.GameInfo').attr("value")
				}, {
				connected() {
					if (!spectate)
						document.addEventListener('keypress', logKey);
					setUpdateRate(50);
				},

				disconnected() {

				},

				received(data) {
					if (data.status == "waiting")
					{
						$("#game_status").html(data.status);
						$("#spec_count").html(data.spec_count);
					}
					else if (data.status == "running")
					{
						$("#game_status").html(data.status);
						$("#spec_count").html(data.spec_count);
						$("#p1_pts").html(data.scores.player1);
						$("#p2_pts").html(data.scores.player2);

						if (ball == null)
							ball = new Ball(data.ball)
						if (paddles[me] == null)
							paddles[me] = new Paddle(data.paddles[me])
						if (paddles[other] == null)
							paddles[other] = new Paddle(data.paddles[other])

						if (!spectate)
						{
							var last_server_input = data.inputs[me][data.inputs[me].length - 1];
							var j = 0;
							while (j < unverified_inputs.length)
							{
								if (unverified_inputs[j].id <= last_server_input)
									unverified_inputs.splice(j, 1);
								else
									j++;
							}
						}

						ball.position_buffer.push([new Date(), data.ball.posX, data.ball.posY]);
						if (spectate)
							paddles[me].position_buffer.push([new Date(), data.paddles[me].posX, data.paddles[me].posY]);
						else
							paddles[me].correctPos(unverified_inputs, data.paddles[me]);
						paddles[other].position_buffer.push([new Date(), data.paddles[other].posX, data.paddles[other].posY]);
					}
					else if (data.status == "finished")
					{
						$("#game_status").html(data.winner + " wins");
						setUpdateRate(0);
						resetCanvas();
						sub.unsubscribe();
						if (!spectate)
							document.removeEventListener('keypress', logKey);
					}
				}
			});
		}
	});
});
