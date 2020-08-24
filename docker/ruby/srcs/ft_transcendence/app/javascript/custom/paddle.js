class Paddle {
	constructor(data) {
		this.posX = data.posX;
		this.posY = data.posY;
		this.width = data.width;
		this.height = data.height;
		this.velocity = data.velocity;
		this.position_buffer = [];
	}

	goUp() {
		this.posY -= this.velocity;
	}

	goDown() {
		this.posY += this.velocity;
	}

	correctPos(unverified_inputs, server_data)
	{
		server_paddle = new Paddle(server_data);
		if (unverified_inputs.length == 0)
		{
			this.posX = server_paddle.posX;
			this.posY = server_paddle.posY;
		}
		else
		{
			unverified_inputs.forEach(function(item) {
				if (item.type == "paddle_up")
					server_paddle.goUp()
				else if (item.type == "paddle_down")
					server_paddle.goDown()
			});
			if (server_paddle.posX != this.posX)
				this.posX = server_paddle.posX;
			if (server_paddle.posY != this.posY)
				this.posY = server_paddle.posY;
		}
	}

	setPos(server_data)
	{
		this.posX = server_data.posX;
		this.posY = server_data.posY;
	}

}

module.exports = Paddle;
