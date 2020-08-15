import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var canvas = document.querySelector('.myCanvas');
  canvas.width = 600;
  canvas.height = 600;
  var ctx = canvas.getContext('2d');

  var sub = consumer.subscriptions.create("GameChannel", {
    connected() {
      setInterval(function(){ sub.send({ body: "posRequest" }) }, 50);
    },

    disconnected() {
    },

    received(data) {
      ctx.clearRect(data.ballPosX - 5, data.ballPosY - 5, 20, 20);
      ctx.beginPath();
      ctx.arc(data.ballPosX, data.ballPosY, 10, 0, 2 * Math.PI, false);
      ctx.stroke();
    }
  });
});
