define [
	'underscore',
	'jquery', 
	'brite',
	'templates/WordSearch',
	'utils/logger',
	'models/WordModel',
	
	'views/WordEditView',
	'views/WordListView',	
	'lib/jquery/jquery.transit'
], (underscore, $, brite, searchTmpl, log, WordModel) ->

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
				@$el.trigger 'search', field: 'Native', text: text
				return false
			'click; button#new-word': (evt)->
				$target = $(evt.currentTarget)
				text = $('#form-search > input').val()
				@$el.trigger 'create', Native: text
				
		postDisplay: ->	
			console.debug("WordSearchView.postDisplay") if log('trace')
			return

		docEvents:
			'edit': (evt, data)->
				return @hideEditView()
					.then =>
						@$el.trigger 'loader', true 
						brite.display('WordEditView', $('#word-edit'), data.word)
							.always (@editView)=> @$el.trigger 'loader', false 
								
			'create': (evt, data)->
				return @hideEditView()
					.then =>
						@$el.trigger 'loader', true 
						brite.display('WordEditView', $('#word-edit'), new WordModel(data))
							.always (@editView)=> @$el.trigger 'loader', false 
						
		daoEvents: {}
			
		hideEditView: ()->
			return $.Deferred().resolve().then =>
					if @editView 
						# Hide the empty inner then remove.  Do not simply call @editView.remove()
						# since that will reset the parent els height, causing FOUS when new edit
						# view is rendered.
						return @editView.hide().then ($el)-> 
							$el?.bEmpty().remove()
			