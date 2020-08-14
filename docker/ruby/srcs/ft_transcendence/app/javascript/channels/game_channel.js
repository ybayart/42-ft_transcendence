import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var canvas = document.querySelector('.myCanvas');
  canvas.width = 600;
  canvas.height = 600;
  var ctx = canvas.getContext('2d');

  consumer.subscriptions.create("GameChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
    	// console.log(data);
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = 'blue';
      ctx.fillRect(data.ballPosX, data.ballPosY, 10, 10);
      
      // Called when there's incoming data on the websocket for this channel
    }
  });
});