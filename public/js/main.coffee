requirejs.config
	baseUrl: "js/"
	paths:
		'brite': 'lib/brite'
		'jquery': 'lib/jquery/jquery'
	shim:
		'brite':
			exports: 'brite'
			deps: ['jquery']
		'lib/jquery/jquery.transit': ['jquery']
		'lib/hogan':
			exports: 'Hogan'
		'templates':
			exports: 'templates'
			deps: ['lib/hogan', 'jquery']

requirejs ['app'], (app)->

	$(document).ready ()->
		app.init()