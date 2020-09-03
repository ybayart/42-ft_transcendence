class Render {
	constructor(canvas)
	{
		this.canvas = canvas;
		if (this.canvas)
			this.ctx = canvas.getContext('2d');
		this.background_color = "black";
		this.paddle_color = "white";
		this.ball_color = "white";
		this.game_status = $("#game_status");
		this.spec_count = $("#spec_count");
		this.score = $("#score");
	}

	config(config)
	{
		$("#canvas_width").html(config.canvas.width);
		$("#canvas_height").html(config.canvas.height);
		$(".paddle_width").first().html(config.paddles[0].width);
		$(".paddle_height").first().html(config.paddles[0].height);
		$(".paddle_velocity").first().html(config.paddles[0].velocity);
		$(".paddle_width").eq(1).html(config.paddles[1].width);
		$(".paddle_height").eq(1).html(config.paddles[1].height);
		$(".paddle_velocity").eq(1).html(config.paddles[1].velocity);
		$("#ball_radius").html(config.ball.radius);
		$("#ball_speed").html(config.ball.speed);
		$("#max_points").html(config.max_points);
	}

	resetCanvas()
	{
		this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
		this.ctx.fillStyle = this.background_color;
		this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
	}

	printBall(ball) {
		this.ctx.beginPath();
		this.ctx.fillStyle = this.ball_color;
		this.ctx.arc(ball.posX, ball.posY, ball.radius, 0, 2 * Math.PI, false);
		this.ctx.fill();
	}

	printPaddle(paddle) {
		this.ctx.fillStyle = this.paddle_color;
		this.ctx.fillRect(paddle.posX, paddle.posY, paddle.width, paddle.height);
	}

	renderWorld(ball, paddles) {
		this.resetCanvas();
		this.printPaddle(paddles[0]);
		this.printPaddle(paddles[1]);
		this.printBall(ball);
	}

	updateSpecCount(count)
	{
		this.spec_count.html(count);
	}
	
	updateGameStatus(text)
	{
		this.game_status.html(text);
	}
	
	updatePts(players)
	{
		let text = players.nicknames[0] + " " + players.scores[0] + " - ";
		text += players.scores[1] + " " + players.nicknames[1];
		this.score.html(text);
	}
}

module.exports = Render;
