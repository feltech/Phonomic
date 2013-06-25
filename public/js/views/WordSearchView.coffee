define [
	'jquery', 
	'brite',
	'template/WordSearch',
	'template/WordSearchList',
	'utils/logger',
	'models/WordSearchModel',
	'lib/jquery/jquery.transit'
], ($, brite, searchTmpl, listTmpl, log, WordSearchModel) ->

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
		docEvents:
			'search': (evt, data)->
				@model.list(data.text)
					.fail (xhr)->
						$('#error-log').append xhr.responseText	
		daoEvents:
			'result; WordSearchModel': (evt)->
				$('#right-panel')
					.hide()
					.html(listTmpl.render(words: evt.daoEvent.result))
					.css(x: $(window).width())
					.show()
					.transition(x: 0, 300, 'snap') 
				console.debug(JSON.stringify(evt.daoEvent)) if log('debug')
				return
			
			