define [
	'underscore',
	'jquery',
	'brite',
	'utils/logger',
	'templates/WordEdit',
	'templates/WordEditLangList',

	'lib/jquery/jquery.transit'
], (_, $, brite, log, editTmpl, langTmpl) ->
	
	transitTime = 200

	brite.registerView 'WordEditView',
		create: (@word)->
			wordRender = _.clone @word
			languageDAO = brite.dao "Language"
			return languageDAO.list().then (languages)=>
				languageIDs = word.Languages?.split '\t'
				if languageIDs?.length
					languageIDs = _(languageIDs).map (id)-> parseInt(id)
					wordRender.Languages = _(languageIDs).map (id)-> _(languages).findWhere(ID: id)	
				return editTmpl.render {word: wordRender, languages: languages}, langList: langTmpl

		init: ->
			@$el.hide()
			return
		destroy: ->
			@$el.parent().height('auto')
			
		postDisplay: ->
#			$(window).on "resize.#{@id}", =>
#				@$el.trigger 'resized'
		
			sourceY = $(window).height() + $(window).scrollTop() + @$el.parent().height()
			console.log "WordEditView transitioning from y=#{sourceY}" if log('trace')
			@$el.css(y: sourceY, opacity: 0)
				.show()
				.transition y: 0, opacity: 1, transitTime, 'snap'
	
			return
			
		resolveWordLanguages: ->
			languageDAO = brite.dao "Language"
			return languageDAO.list().then (languages)=>
				languageIDs = _.compact(@word.Languages?.split '\t')
				if languageIDs?.length
					languageIDs = _(languageIDs).map (id)-> parseInt(id)
					return _(languageIDs).map (id)-> _(languages).findWhere(ID: id)	
				else
					return []
		
		hide: ->
			return $.Deferred (defer)=>
#				@$el.transition y: -(@$el.height()+@$el.offset().top), opacity: 0, transitTime, =>
				if (@$el and @$el.css('opacity') != 0)
					@$el.transition opacity: 0, transitTime, =>
						defer.resolve(@$el)
				else
					defer.resolve(@$el)
	
		remove: ->
			@hide().then => @$el?.parent().bEmpty()
		
		events:	
			'click; button.cancel': (evt)->
				@remove()
		
			'click; button#search-roman': (evt)->
				@$el.trigger 'search', field: 'Roman', text: $('#roman').val()
			'click; button#search-native': (evt)->
				@$el.trigger 'search', field: 'Native', text: $('#native').val()
			'click; button#search-phonetic': (evt)->
				@$el.trigger 'search', field: 'Phonetic', text: $('#phonetic').val()
		
			'click; button#add-language': (evt)->
				languageID = $('select#languages').val()
				if (languageID) 
					@word.Languages = _(@word.Languages.split '\t').union([languageID]).join('\t')
					@resolveWordLanguages().then (languages)->
						$('#language-list').html(langTmpl.render Languages: languages)
				
			'click; button.delete-language': (evt)->
				languageRef = $(evt.currentTarget).bEntity('Language')
				@word.Languages = _(@word.Languages.split '\t').without(languageRef.id).join('\t')
				languageRef.$el.transition 'opacity': 0, ->
					languageRef.$el.remove()
#				@resolveWordLanguages().then (languages)->
#					$('#language-list').html(langTmpl.render Languages: languages)
		
		winEvents:
			'resize': ->
				console.log "WordEditView window size changed: #{$(window).width()}x#{$(window).height()}"
				@$el.parent().height @$el.height()
#				@$el.width @$el.parent().width()
				return false;
		daoEvents: {}
