window.app.views.RoomSetting = Backbone.View.extend({
	model: window.app.models.newRoomSetting,
	tagName: 'div',
	initialize: function() {
		this.template = _.template($('.room_settings-template').html());
	},
	events: {
		'click #modalSend': 'update',
		'click #modalDelete': 'delete'
	},
	update: function() {
		this.model.set('name', $('#modal input.name').val());
		this.model.set('privacy', $('#modal input.privacy').val());

		this.model.save({"url": "/api/room_settings/1"}, {
			success: function(response) {
				console.log('Successfully patch settings');
			},
			error: function(err) {
				console.log('Failed to patch settings!');
			}
		});
	},
	delete: function() {
		this.model.destroy({
			success: function(response) {
				console.log('Successfully DELETED room');
			},
			error: function(err) {
				console.log('Failed to delete room!');
			}
		});
	},
	render: function() {
		this.$el.html(this.template(this.model.attributes));
		return this;
	}
});

window.app.views.RoomSettings = Backbone.View.extend({
	model: window.app.collections.newRoomSettings,
	el: $('#modal'),
	initialize: function(option, params) {
		var self = this;
		this.model.on('add', this.render, this);
		this.model.reset();
		this.model.fetch({"url": "/api/room_settings/" + params});
	},
	render: function() {
		var self = this;
		$('#modal').html('');
		_.each(this.model.toArray(), function(item) {
			console.log(item.attributes);
			$('#modal').html((new window.app.views.RoomSetting({model: item})).render().$el);
		});
		$('#modalSend').addClass('room-settings-update');
		$('#modal').modal('show');
		return this;
	}
});
