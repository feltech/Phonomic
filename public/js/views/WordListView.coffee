define [
	'underscore',
	'jquery',
	'brite',
	'templates/WordSearchList',
	'utils/logger',

	'lib/jquery/jquery.transit'
], (_, $, brite, listTmpl, log) ->
	
	transitTime = 200

	brite.registerView 'WordListView',
		create: ->
			@dao = brite.dao "Word"
			@transition = $.Deferred().resolve()
			return @dao.cache().then (cache)-> 
				return listTmpl.render words: cache

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
			return $.Deferred (defer)=>
				@$el.transition opacity: 0, transitTime, 'ease', =>
					defer.resolve(@$el)
				return
		
		events:
			'click; li': (evt)->
				wordRef = $(evt.currentTarget).bEntity 'Word'
				@dao.cache(ID: parseInt(wordRef.id)).done (word)=>
					@$el.trigger 'edit', word: word
				return false	
		
		docEvents: 
			'search': (evt, data)->
				if @transition.state() == 'resolved'
					@transition = @hide()
					@dao.list(data.field, data.text)
				return

		daoEvents:
			'result; Word': (evt)->
				if evt.daoEvent.action == 'list'
					@transition.then =>
						return $.Deferred (@transition)=>
							@$el.html(listTmpl.render(words: evt.daoEvent.result))
								.css(x: $(window).width())
								.transition x: 0, opacity: 1, transitTime, 'snap', =>
									@transition.resolve()
								
				console.debug(JSON.stringify(evt.daoEvent)) if log('trace')
				return
			