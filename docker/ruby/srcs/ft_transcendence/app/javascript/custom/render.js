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
	
	updateGameStatus(stat, player2)
	{
		let text;
		if (stat == "waiting")
		{
			if (player2)
				text = "waiting for " + player2 + "...";
			else
				text = "waiting for player...";
		}
		else
			text = stat;
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
