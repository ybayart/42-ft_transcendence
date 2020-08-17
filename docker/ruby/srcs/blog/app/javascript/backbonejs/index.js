window.app = {}

_.templateSettings = {
	interpolate: /\{\{\=(.+?)\}\}/g,
	evaluate: /\{\{(.+?)\}\}/g
};

require("backbonejs/models")
require("backbonejs/collections")
//require(baseDir+"/routers/post")
//require("./templates")
//require("./views")
