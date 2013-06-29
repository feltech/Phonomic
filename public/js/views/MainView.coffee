define [
	'jquery', 
	'brite',
	
	'views/WordSearchView'
	'views/WordListView'
], ($, brite) ->
	brite.registerView 'MainView', emptyParent: true,
		create: ()->
			return "<div>"
		postDisplay: ()->
			brite.display 'WordSearchView', @$el
			brite.display 'WordListView', $('#right-panel')
			return true