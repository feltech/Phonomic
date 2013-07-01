requirejs.config
	baseUrl: "js/"
	paths:
		'brite': 'lib/brite'
		'jquery': 'lib/jquery/jquery'
		'hogan': 'lib/hogan'
		'underscore': 'lib/underscore/underscore'
		'underscore.string': 'lib/underscore/underscore.string'
	shim:
		'brite':
			exports: 'brite'
			deps: ['jquery']
		'lib/jquery/jquery.transit': ['jquery']
		'hogan':
			exports: 'Hogan'
		'underscore':
			exports: '_'

requirejs ['app'], (app)->

	$(document).ready ()->
		app.init()