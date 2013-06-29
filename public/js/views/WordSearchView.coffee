define [
	'underscore',
	'jquery', 
	'brite',
	'templates/WordSearch',
	'utils/logger',
	
	'views/WordEditView',
	'views/WordListView',	
	'lib/jquery/jquery.transit'
], (underscore, $, brite, searchTmpl, log) ->

	transitTime = 500

	brite.registerView 'WordSearchView',	
		create: ()->
			return searchTmpl.render()
		events:
			'submit; #form-search': (evt)->
				# Prevent form from submitting normally.
				evt.preventDefault()
				$target = $(evt.currentTarget)
				# Clear previous error log
				$('#error-log').bEmpty() 
				# Get the query text
				text = $('input', $target).val()
				@$el.trigger 'search', field: 'Roman', text: text
				return false
		postDisplay: ->
			console.debug("WordSearchView.postDisplay") if log('trace')
			return

		docEvents:
			'edit': (evt, data)->
				return $.Deferred().resolve().then =>
						if @editView 
							# Hide then empty inner then remove.  Do not simply call @editView.remove()
							# since that will reset the parent els height, causing FOUS when new edit
							# view is rendered.
							return @editView.hide().then ($el)-> 
								$el?.bEmpty().remove()
					.then =>
						brite.display('WordEditView', $('#word-edit'), data.word)
							.done (@editView)=> 
								$('#word-edit', @$el).height @editView.$el.height()
		daoEvents: {}
			
			