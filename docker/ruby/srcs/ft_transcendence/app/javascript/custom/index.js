$(function() {
	$('#new_room_message').on('ajax:success', function(a, b,c ) {
		$(this).find('input[type="text"]').val('');
	});
});

document.addEventListener("turbolinks:load", () => {
	$("time.timeago").timeago();
	$('[name=toast-alert]').toast('show').attr('name', 'toast-alert-printed');
});
