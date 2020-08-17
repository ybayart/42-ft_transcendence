window.app.views.Post = Backbone.View.extend({
	model: new window.app.models.Post,
	tagName: 'div',
	initialize: function() {
		this.template = _.template($('.post-line-template').html());
	},
	render: function() {
		this.$el.html(this.template(this.model.toJSON()));
		return this;
	}
});

window.app.views.Posts = Backbone.View.extend({
	model: new window.app.collections.Posts,
	el: $('.posts-list'),
	initialize: function() {
		var self = this;
		this.model.on('add', this.render, this);
		this.model.fetch({
			success: function(response) {
				_.each(response.toJSON(), function(item) {
					console.log('Successfully GOT blog with title: ' + item.title);
				})
			},
			error: function() {
				console.log('Failed to get blogs!');
			}
		});
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
