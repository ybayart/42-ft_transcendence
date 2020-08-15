import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var canvas = document.querySelector('.myCanvas');
  canvas.width = 600;
  canvas.height = 600;
  var ctx = canvas.getContext('2d');

  var paddlePosY = 50;

  var sub = consumer.subscriptions.create("PaddleChannel", {
  	connected() {
      document.addEventListener('keypress', logKey);
      function logKey(e)
      {
        if (e.key == 'w')
          sub.perform('up', {});  
        if (e.key == 's')
          sub.perform('down', {});  
      }
	  // Called when the subscription is ready for use on the server
	},

	disconnected() {
  		// Called when the subscription has been terminated by the server
	},

	received(data) {
		ctx.clearRect(5, paddlePosY, 15, 50);
		paddlePosY = data.paddlePosY;
		ctx.fillRect(5, paddlePosY, 15, 50);
		// Called when there's incoming data on the websocket for this channel
 	}
  });

});
