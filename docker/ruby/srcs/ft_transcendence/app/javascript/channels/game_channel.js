import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var canvas = document.querySelector('.myCanvas');
  canvas.width = 600;
  canvas.height = 600;
  var ctx = canvas.getContext('2d');

  var sub = consumer.subscriptions.create("GameChannel", {
    connected() {
      document.addEventListener('keypress', logKey);
      function logKey(e)
      {
        if (e.key == 'w')
        {
          console.log("w pressed");
          sub.perform('up', {});  
        }
        if (e.key == 's')
        {
          console.log("s pressed");
          sub.perform('down', {});  
        }
      }
      setInterval(function(){ sub.send({ body: "posRequest" }) }, 50);
    },

    disconnected() {
    },

    received(data) {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillRect(5, data.paddlePosY, 15, 50);
      ctx.beginPath();
      ctx.arc(data.ballPosX, data.ballPosY, 10, 0, 2 * Math.PI, false);
      ctx.stroke();
    }
  });
});