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
		console.log(data);
		if (window.controller.controller == "rooms" && window.controller.action == "show") {
			updateView();
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
