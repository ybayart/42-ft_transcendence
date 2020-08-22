window.app.collections.RoomMembers = Backbone.Collection.extend({
	model: window.app.models.RoomMember
});

window.app.collections.newRoomMembers = new window.app.collections.RoomMembers;
