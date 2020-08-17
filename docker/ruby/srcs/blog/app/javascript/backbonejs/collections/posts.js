window.app.collections.Posts = Backbone.Collection.extend({
	url: '/api/posts',
	model: window.app.models.Post
});

window.app.collections.newPosts = new window.app.collections.Posts;
