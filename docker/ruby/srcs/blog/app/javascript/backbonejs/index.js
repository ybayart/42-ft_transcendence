window.app = {collections: {}, models: {}, views: {}}

require("backbonejs/models")
require("backbonejs/collections")
require("backbonejs/views")
//require("./templates")
//require("./views")

Backbone._sync = Backbone.sync;
Backbone.sync = function(method, model, options) {
	if (!options.noCSRF) {
		var beforeSend = options.beforeSend;

		// Set X-CSRF-Token HTTP header
		options.beforeSend = function(xhr) {
			var token = $('meta[name="csrf-token"]').attr('content');
			if (token) { xhr.setRequestHeader('X-CSRF-Token', token); }
			if (beforeSend) { return beforeSend.apply(this, arguments); }
		};
	}
	return Backbone._sync(method, model, options);
};
