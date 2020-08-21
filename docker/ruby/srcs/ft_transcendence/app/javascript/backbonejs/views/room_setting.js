window.app.views.RoomSetting = Backbone.View.extend({
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

		Backbone.sync("update", this.model,{
			"url": "/api/room_settings/" + $('#room_message_room_id').val(),
			success: function(response) {
				$('#modal').modal('hide');
			},
			error: function(err) {
				console.log();
				$('#modalOutput').html('Failed to edit settings!');
				$.each(err.responseJSON, function(idx, item) {
					$('#modalOutput').append("<br>> " + idx + ": " + item);
				});
				$('#modalOutput').fadeIn();
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
	initialize: function() {
		var self = this;
		this.model.on("add", this.render, this);
		this.model.fetch({"url": "/api/room_settings/" + $('#room_message_room_id').val()});
	},
	render: function() {
		var self = this;
		$('#modal').html('');
		_.each(this.model.toArray(), function(item) {
			console.log(item.attributes);
			$('#modal').html((new window.app.views.RoomSetting({model: item})).render().$el);
		});
		$('#modal').modal('show');
		return this;
	}
});
