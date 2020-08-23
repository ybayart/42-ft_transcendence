class Ball {
	constructor(data) {
		this.posX = data.posX;
		this.posY = data.posY;
		this.radius = data.radius;
		this.velocityX = data.velocityX;
		this.velocityY = data.velocityY;
		this.position_buffer = [];
	}
}

module.exports = Ball;
