class Paddle {
	constructor(data) {
		this.posX = data.posX;
		this.posY = data.posY;
		this.width = data.width;
		this.height = data.height;
		this.velocity = data.velocity;
	}
}

module.exports = Paddle;
