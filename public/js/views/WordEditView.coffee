define [
	'underscore',
	'jquery',
	'brite',
	'templates/WordEdit',
	'utils/logger',

	'lib/jquery/jquery.transit'
], (_, $, brite, editTmpl, log) ->
	
	transitTime = 300

	brite.registerView 'WordEditView',
		create: (word)->
			@dao = brite.registerDao word
			@model = word

			return editTmpl.render word: @model

		init: ->
			@$el.hide()
			return
		destroy: ->
				
			
		postDisplay: ->
			$(window).on "resize.#{@id}", =>
				@$el.trigger 'resized'
		
			sourceY = $(window).height() + $(window).scrollTop() + @$el.parent().height()
			console.log "WordEditView transitioning from y=#{sourceY}" if log('trace')
			@$el.css(y: sourceY, opacity: 0)
				.show()
				.transition y: 0, opacity: 1, transitTime, 'ease'
	
			return
		hide: ->
			return $.Deferred (defer)=>
#				@$el.transition y: -(@$el.height()+@$el.offset().top), opacity: 0, transitTime, =>
				@$el.transition opacity: 0, transitTime, =>
					defer.resolve(@$el)
		
		events:		
			'click; #search-roman': (evt)->
				evt.preventDefault()
				@$el.trigger 'search', field: 'Roman', text: $('#roman').val()
				return false;
			'click; #search-native': (evt)->
				evt.preventDefault()
				@$el.trigger 'search', field: 'Native', text: $('#native').val()
				return false;
		
		docEvents:
			'resized': ->
				console.log "WordEditView window size changed: #{$(window).width()}x#{$(window).height()}"
				@$el.parent().height @$el.height()
#				@$el.width @$el.parent().width()
				return false;
		daoEvents: {}
