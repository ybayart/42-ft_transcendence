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
			var other = me == 1 ? 0 : 1;
			if (window.location.href.indexOf("test") == -1) //spec
			{
				me = 0;
				other = 1;
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
					unverified_inputs.push(inputs_id);
					inputs_id++;
					if (paddles[me])
						paddles[me].goUp()
				}
				else if (e.key == 's')
				{
					sub.perform('input', { type: "paddle_down", id: inputs_id });
					unverified_inputs.push(inputs_id);
					inputs_id++;
					if (paddles[me])
						paddles[me].goDown()
				}
				else if (e.key == ' ')
				{
					sub.perform('throw_ball', { id: inputs_id });
					inputs_id++;
				}
			}

			function interpolate(entity) {
				var render_timestamp = new Date() - (1000.0 / 10);

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
				//interpolate(paddles[me]);
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
					if (window.location.href.indexOf("test") != -1)
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

						data.inputs[me].forEach(function(server_id) {
							unverified_inputs.forEach(function(client_id, index) {
								if (server_id == client_id)
									unverified_inputs.splice(index, 1);
							});
						});

						// INTERPOLATION BALL - It works wtf
						ball.position_buffer.push([new Date(), data.ball.posX, data.ball.posY]);
						paddles[me].correctPos(unverified_inputs, data.paddles[me]);
						// A VIRER APRES C'EST POUR TEST
						//paddles[me].position_buffer.push([new Date(), data.paddles[me].posX, data.paddles[me].posY]);
						// WITHOUT INTERPOLATION
						//	paddles[other].setPos(data.paddles[other]);
						// WITH INTERPOLATION
						paddles[other].position_buffer.push([new Date(), data.paddles[other].posX, data.paddles[other].posY]);

						console.log(unverified_inputs);
					}
					else if (data.status == "finished")
					{
						$("#game_status").html(data.winner + " wins");
						setUpdateRate(0);
						resetCanvas();
						sub.unsubscribe()
						if (window.location.href.indexOf("test") != -1)
							document.removeEventListener('keypress', logKey);
					}
				}
			});
		}
	});
});
