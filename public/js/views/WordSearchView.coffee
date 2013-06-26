define [
	'underscore',
	'jquery', 
	'brite',
	'templates/WordSearch',
	'templates/WordSearchList',
	'utils/logger',
	'models/WordSearchModel',
	'views/WordEditView',
	
	'lib/jquery/jquery.transit'
], (underscore, $, brite, searchTmpl, listTmpl, log, WordSearchModel, WordEditView) ->

	brite.registerView 'WordSearch',	
		create: ()->
			@model = brite.registerDao new WordSearchModel
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
				@$el.trigger 'search', text: text
				return false
			'click; #word-list > li': (evt)->
				wordRef = $(evt.currentTarget).bEntity 'Word'
				@$el.trigger 'edit', id: parseInt(wordRef.id, 10)
				return false
				
		docEvents:
			'search': (evt, data)->
				@model.list(data.text)
					.fail (xhr)->
						$('#error-log').append xhr.responseText	
						
			'edit': (evt, data)->
				$('#word-edit', @$el).bEmpty()
				@model.cache(ID: data.id).done (word)->
					brite.display 'WordEditView', $('#word-edit', @$el), word
						
		daoEvents:
			'result; WordSearchModel': (evt)->
				if evt.daoEvent.action == 'list'
					$('#right-panel')
						.hide()
						.html(listTmpl.render(words: evt.daoEvent.result))
						.css(x: $(window).width())
						.show()
						.transition(x: 0, 300, 'snap') 
				console.debug(JSON.stringify(evt.daoEvent)) if log('debug')
				return
			
			