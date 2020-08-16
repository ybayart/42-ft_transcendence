import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var canvas = document.querySelector('.myCanvas');
  canvas.width = 600;
  canvas.height = 600;
  var ctx = canvas.getContext('2d');

  var ballPosY = 20;
  var ballPosX = 50;
  var velocityY = 0;
  var velocityX = 1;
  var time = 0;

  function printBall()
  {	  
  	ctx.clearRect(ballPosX - 20, ballPosY - 20, 40, 40);
    ctx.beginPath();
    ctx.arc(ballPosX, ballPosY, 10, 0, 2 * Math.PI, false);
    ctx.stroke();
  }

  var sub = consumer.subscriptions.create("GameChannel", {
    connected() {
	  // PADDLE
      document.addEventListener('keypress', logKey);
      function logKey(e)
      {
        if (e.key == 'w')
          sub.perform('player1_up', {});  
		    if (e.key == 's')
          sub.perform('player1_down', {});  
      }

	  // BALL
  	  setInterval(function() {
  	  	time += 10;
  	  	ballPosX += velocityX;
  		  ballPosY += velocityY;
  		  if (ballPosX > 100 || ballPosX < 20)
  			 velocityX *= -1;
  		  printBall();
      }, 10);
	  
    //   setInterval(function() {
	   // 	sub.send({
    //     'ballPosX': ballPosX,
				// 'ballPosY': ballPosY,
				// 'time': time});
		  // }, 50);
    },

    disconnected() {
    },

    received(data) {
  		console.log(data);
  		if (data)
  		{
  			ballPosX = data.ballPosX;
  			ballPosY = data.ballPosY;
  			velocityX = data.velocityX;
  			velocityY = data.velocityY;
  			printBall();
  		}
    }
  });
});
