var Posts = Backbone.Collection.extend({
	url: '/posts',
	model: window.app.Post
});

window.app.Posts = Posts;
