import consumer from "./consumer"

var sub = consumer.subscriptions.create("PaddleChannel", {
  connected() {
  	document.addEventListener('keypress', logKey);

	function logKey(e)
	{
		if (e.key == 'w')
		{
			sub.perform('up', {});	
		}
		if (e.key == 's')
		{
			sub.perform('down', {});	
		}
	}
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
