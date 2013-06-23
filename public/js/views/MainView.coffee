define [
	'jquery', 
	'brite',
	'templates',
	'views/WordSearchView'
], ($, brite, templates) ->
	brite.registerView 'MainView', emptyParent: true,
		create: ()->
			return "<div>"
		postDisplay: ()->
			brite.display 'WordSearch', @$el
			return true