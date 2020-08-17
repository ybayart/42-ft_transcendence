window.app = {collections: {}, models: {}, views: {}}

require("backbonejs/models")
require("backbonejs/collections")
require("backbonejs/views")
//require("./templates")
//require("./views")

var postsView = new window.app.views.Posts();
