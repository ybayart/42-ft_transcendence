window.app.collections.RoomUsers = Backbone.Collection.extend({
	model: window.app.models.RoomUser
});

window.app.collections.newRoomUsers = new window.app.collections.RoomUsers;
