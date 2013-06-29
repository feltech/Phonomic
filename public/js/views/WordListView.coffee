define [
	'underscore',
	'jquery',
	'brite',
	'models/WordListModel',
	'templates/WordSearchList',
	'utils/logger',

	'lib/jquery/jquery.transit'
], (_, $, brite, WordListModel, listTmpl, log) ->
	
	transitTime = 200

	brite.registerView 'WordListView',
		create: (words)->
			@model = brite.registerDao new WordListModel(words)
			return @model.cache().then (cache)-> 
				return $.Deferred().resolve(listTmpl.render words: cache)

		init: ->
			console.debug("WordListView.init: #{@$el.length}") if log('trace')
			return
		destroy: ->			
			console.debug("WordListView.destroy") if log('trace')
			return
		postDisplay: ->
			console.debug("WordListView.postDisplay: #{@$el.length}") if log('trace')
			return
		hide: ->
			console.debug("WordListView.hide") if log('trace')
#			@$el.css(opacity: 1)
			return $.Deferred (defer)=>
				@$el.transition opacity: 0, transitTime, 'ease', =>
					defer.resolve(@$el)
				return
		
		events:
			'click; li': (evt)->
				wordRef = $(evt.currentTarget).bEntity 'Word'
				@model.cache(ID: parseInt(wordRef.id)).done (word)=>
					@$el.trigger 'edit', word: word
				return false	
		
		docEvents: 
			'search': (evt, data)->
#				hide = @hide()
				fetch = @model.list(data.field, data.text)
				$.when(fetch)
					.then ->
						console.debug("WordListView.event.search: fetch and transition complete") if log('trace')
						return
					.fail (xhr)->
						$('#error-log').append xhr.responseText	
				return

		daoEvents:
			'result; WordListModel': (evt)->
				if evt.daoEvent.action == 'list'
					@hide().done =>
						@$el.html(listTmpl.render(words: evt.daoEvent.result))
							.css(x: $(window).width())
							.show()
							.transition(x: 0, opacity: 1, transitTime, 'snap') 
				console.debug(JSON.stringify(evt.daoEvent)) if log('trace')
				return
