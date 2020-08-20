window.app.collections.RoomSettings = Backbone.Collection.extend({
	model: window.app.models.RoomSetting
});

window.app.collections.newRoomSettings = new window.app.collections.RoomSettings;
