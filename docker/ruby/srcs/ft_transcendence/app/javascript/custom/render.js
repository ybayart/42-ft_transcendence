class Render {
	constructor(canvas)
	{
		this.canvas = canvas;
		this.ctx = canvas.getContext('2d');
		this.background_color = "blue";
		this.paddle_color = "black";
		this.ball_color = "black";
		this.game_status = $("#game_status");
		this.spec_count = $("#spec_count");
		this.pts = [];
		this.pts[0] = $("#p1_pts");
		this.pts[1] = $("#p2_pts");
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
	
	updateGameStatus(stat)
	{
		this.game_status.html(stat);
	}
	
	updatePts(player, score)
	{
		this.pts[player - 1].html(score);
	}
}

module.exports = Render;
