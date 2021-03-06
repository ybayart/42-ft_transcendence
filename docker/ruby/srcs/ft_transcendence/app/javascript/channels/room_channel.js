import consumer from "./consumer"

var sub = null;

$(document).on('turbolinks:load', function () {
	if (sub)
	{
		sub.unsubscribe();
		sub = null;
	}

	sub = consumer.subscriptions.create({
			channel: "RoomChannel",
			room: $('[data-channel-subscribe="room"]').data('room-id')
		}, {
		connected() {
		},

		disconnected() {
		},

		received(data) {
			if (data.type == "message") {
				if (window.mutes.includes(data.content.user_id) == false) {
					$('input#room_message_message').val('');
					var element = $('[data-channel-subscribe="room"]'),
						room_id = element.data('room-id'),
						messageTemplate = $('[data-role="message-template"]');
					var content = messageTemplate.children().clone(true, true);
					content.find('[data-role="user-avatar"]').attr("src", data.content.pic).attr("title", data.content.name.nick);
					content.find('[data-role="message-user"]').append('<span id="chat_nickname">' + data.content.name.display + '</span>');
					content.find('[id="chat_nickname"]').wrap("<a href =" + data.content.link_profile + "></a>");
					if (content.find('[id="chat_nickname"]').html() != $("#nav-nickname").attr("usernickname"))
						content.find('[data-role="message-user"]').append(' <button type="button" data-toggle="modal" data-target="#exampleModal" class="invite_button">Invite to play</button>')
					content.find('[data-role="message-text"]').text(data.content.message);
					content.find('[data-role="message-date"] > time').attr("datetime", data.content.date.format).text(data.content.date.human).addClass("timeago");
					element.prepend(content);
					$("time.timeago").timeago();
					window.invite_button = $(".invite_button");
					if (window.invite_button)
					{
						window.invite_button.click(function() {
							window.chat_nickname = $(this).parent().find("#chat_nickname").html();
						});
					}
				}
			}
			else if (data.type == "join" || data.type == "left")
			{
				updateView();
			}
			else if (data.type == "update" || data.type == "delete")
			{
				if (window.controller.controller == "rooms" && window.controller.action == "show" && $('#room_message_room_id').val() == data.content.id)
				{
					Turbolinks.visit(window.location.toString(), {action: 'replace'});
				}
			}
		}
	});
});
