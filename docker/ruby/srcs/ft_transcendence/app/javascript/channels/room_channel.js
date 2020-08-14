import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
	consumer.subscriptions.create({
			channel: "RoomChannel",
			room: $('[data-channel-subscribe="room"]').data('room-id')
		}, {
		connected() {
		},

		disconnected() {
		},

		received(data) {
			console.log(data);
			if (data.type == "message") {
				$('input#room_message_message').val('');
				var element = $('[data-channel-subscribe="room"]'),
					room_id = element.data('room-id'),
					messageTemplate = $('[data-role="message-template"]');
				var content = messageTemplate.children().clone(true, true);
				content.find('[data-role="user-avatar"]').attr("src", data.content.pic).attr("title", data.content.nickname);
				content.find('[data-role="message-text"]').text(data.content.message);
				content.find('[data-role="message-date"] > time').attr("datetime", data.content.date).addClass("timeago");
				element.append(content);
				$("time.timeago").timeago();
			}
		}
	});
});
