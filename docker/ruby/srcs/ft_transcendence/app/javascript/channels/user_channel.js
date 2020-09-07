import consumer from "./consumer"

consumer.subscriptions.create("UserChannel", {
	// Called once when the subscription is created.
	initialized() {
		this.update = this.update.bind(this)
	},

	// Called when the subscription is ready for use on the server.
	connected() {
		this.install()
		this.update()
	},

	// Called when the WebSocket connection is closed.
	disconnected() {
		this.uninstall()
	},

	received(data) {
		if (data.type == "message") {
			if ($('#nav-nickname').attr('userid') == data.content.user_id)
				$('input#dm_message_message').val('');
			var dm_id = $('#dm_message_dm_id').val(),
				messageTemplate = $('[data-role="message-template"]');
			if (dm_id == data.content.dm_id) {
				var content = messageTemplate.children().clone(true, true);
				content.find('[data-role="user-avatar"]').attr("src", data.content.pic).attr("title", data.content.name.nick)
				content.find('[data-role="message-user"]').text(data.content.name.display);
				content.find('[data-role="message-text"]').text(data.content.message);
				content.find('[data-role="message-date"] > time').attr("datetime", data.content.date.format).text(data.content.date.human).addClass("timeago");
				$('div.chat').prepend(content);
				$("time.timeago").timeago();
			}
		} else {
			if (window.controller.controller == "rooms" && window.controller.action == "show") {
				updateView();
			}
		}
	},

	// Called when the subscription is rejected by the server.
	rejected() {
		this.uninstall()
	},

	update() {
		this.documentIsActive ? this.online() : this.offline()
	},

	online() {
		this.perform("online")
	},

	offline() {
		this.perform("offline")
	},

	install() {
		window.addEventListener("focus", this.update)
		window.addEventListener("blur", this.update)
		document.addEventListener("turbolinks:load", this.update)
		document.addEventListener("visibilitychange", this.update)
	},

	uninstall() {
		window.removeEventListener("focus", this.update)
		window.removeEventListener("blur", this.update)
		document.removeEventListener("turbolinks:load", this.update)
		document.removeEventListener("visibilitychange", this.update)
	},

	get documentIsActive() {
		return document.visibilityState == "visible" && document.hasFocus()
	},
});
