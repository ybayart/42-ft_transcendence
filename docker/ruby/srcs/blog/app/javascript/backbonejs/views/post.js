window.app.views.Post = Backbone.View.extend({
	model: window.app.models.newPost,
	tagName: 'div',
	initialize: function() {
		this.template = _.template($('.post-line-template').html());
	},
	render: function() {
		this.$el.html(this.template(this.model.attributes));
		return this;
	}
});

window.app.views.Posts = Backbone.View.extend({
	model: window.app.collections.newPosts,
	el: $('.posts-list'),
	initialize: function() {
		var self = this;
		this.model.on('all', this.render, this);
		this.model.fetch();
	},
	render: function() {
		var self = this;
		$('.posts-list').html('');
		_.each(this.model.toArray(), function(blog) {
			$('.posts-list').append((new window.app.views.Post({model: blog})).render().$el);
		});
		return this;
	}
});
