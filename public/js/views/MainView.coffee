define [
	'jquery', 
	'brite',
	
	'views/WordSearchView'
	'views/WordListView'
], ($, brite) ->
	brite.registerView 'MainView', emptyParent: true,
		loadingCount: 0
		create: ()->
			return "<div>"
		postDisplay: ()->
			brite.display('WordSearchView', @$el).then -> $('#loader').addClass('hidden')
			brite.display 'WordListView', $('#right-panel')
			return true
		docEvents:
			'loader': (evt, isShown)->
				@loader(isShown)
		daoEvents:
			'result; Word': (evt)->
				if evt.daoEvent.action == 'list' and $('#splash').length	
					$('#splash').transition opacity: 0, 100, -> $('#splash').remove()
			
		loader: (isShown)->
			if isShown then @loadingCount++ else @loadingCount--
			if @loadingCount then $('#loader').removeClass('hidden') else $('#loader').addClass('hidden')
			return @loadingCount