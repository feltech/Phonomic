define [
	'jquery', 
	'brite',
	'views/WordSearchView'
], ($, brite, WordSearchView) ->
	brite.registerView 'MainView', emptyParent: true,
		create: ()->
			return "<div>"
		postDisplay: ()->
			brite.display 'WordSearch', @$el
			return true