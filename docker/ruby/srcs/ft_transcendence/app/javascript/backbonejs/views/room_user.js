window.app.views.RoomUser = Backbone.View.extend({
	model: window.app.models.newRoomUser,
	tagName: 'div',
	initialize: function() {
		this.template = _.template($('.room_users-template').html());
	},
	render: function() {
		this.$el.html(this.template(this.model.attributes));
		return this;
	}
});

window.app.views.RoomUsers = Backbone.View.extend({
	model: window.app.collections.newRoomUsers,
	el: $('.room_users'),
	initialize: function() {
		var self = this;
		this.model.on('add', this.render, this);
		this.model.fetch({"url": "/api/room_users/" + $('#room_message_room_id').val()});
	},
	render: function() {
		var self = this;
		$('.room_users').html('');
		_.each(this.model.toArray(), function(item) {
			$('.room_users').append((new window.app.views.RoomUser({model: item})).render().$el);
		});
		return this;
	}
});
