window.app.views.PostsView = Backbone.View.extend({
	model: window.app.collections.Posts,
	el: $('#posts')
	initialize: function() {
		this.model.on('add', this.render(), this);
	}
	render: function() {
		this.$el.html('');
	}
});
