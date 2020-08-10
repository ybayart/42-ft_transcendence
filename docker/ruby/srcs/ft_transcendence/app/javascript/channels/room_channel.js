import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
	consumer.subscriptions.create({
			channel: "RoomChannel",
			room: $('[data-channel-subscribe="room"]').data('room-id')
		}, {
		connected() {
			console.log("hello world");
			console.log($('[data-channel-subscribe="room"]').data('room-id'));
		},

		disconnected() {
		},

		received(data) {
			var element = $('[data-channel-subscribe="room"]'),
				room_id = element.data('room-id'),
				messageTemplate = $('[data-role="message-template"]');
			console.log(data);
			var content = messageTemplate.children().clone(true, true);
	//		content.find('[data-role="user-avatar"]').attr('src', data.user_avatar_url);
			content.find('[data-role="message-text"]').text(data.message);
			content.find('[data-role="message-date"]').text(data.updated_at);
			element.append(content);
			element.animate({ scrollTop: element.prop("scrollHeight")}, 1000);
		}
	});
});
