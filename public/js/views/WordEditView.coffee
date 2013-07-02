define [
	'underscore',
	'jquery',
	'brite',
	'utils/logger',
	'templates/WordEdit',
	'templates/WordEditLangList',
	'models/WordModel',

	'lib/jquery/jquery.transit',
	'lib/jquery/bootstrap'
], (_, $, brite, log, editTmpl, langTmpl, WordModel) ->
	
	transitTime = 200

	brite.registerView 'WordEditView',
		create: (@word)->
			wordRender = _.clone @word
			languageDAO = brite.dao "Language"
			return languageDAO.list().then (languages)=>
				languageIDs = _.compact word.Languages?.split '\t'
				languageIDs = _(languageIDs).map (id)-> parseInt(id)
				wordRender.Languages = _(languageIDs).map (id)-> _(languages).findWhere(ID: id)	
				return editTmpl.render {word: wordRender, languages: languages}, langList: langTmpl

		init: ->
			@$el.hide()
			return
		destroy: ->
			@$el.parent().height('auto')
			
		postDisplay: ->
			sourceY = $(window).height() + $(window).scrollTop() + @$el.parent().height()
			console.log "WordEditView transitioning from y=#{sourceY}" if log('trace')
			@$el.parent().height @$el.height()
			@$el.css(y: sourceY, opacity: 0.5)
				.show()
				.transition y: 0, opacity: 1, transitTime, 'snap'
			return
			
		resolveWordLanguages: ->
			languageDAO = brite.dao "Language"
			return languageDAO.list().then (languages)=>
				languageIDs = _.compact(@word.Languages?.split '\t')
				languageIDs = _(languageIDs).map (id)-> parseInt(id)
				return _(languageIDs).map (id)-> _(languages).findWhere(ID: id)	
		
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
		
		
			'submit; #form-edit': (evt)->
				evt.preventDefault()
				_(@word).extend
					Roman: _.clean $('#roman').val() 
					Native: _.clean $('#native').val()
					Phonetic: _.clean $('#phonetic').val()
				$alert = $('#submit-state').removeClass('alert-success').removeClass('alert-warning').addClass('alert-info');
				
				$('strong', $alert).html "Sending." 
				$('span', $alert).html "The changes are being sent to the server, please wait..."
				$alert.removeClass('invisible').css(opacity: 1)
			
				wordDAO = brite.dao 'Word'
							
				@$el.trigger 'loader', true 
				wordDAO[if @word.ID then 'update' else 'create'](@word).done =>
					$alert = $('#submit-state').addClass('alert-success').removeClass('alert-warning').removeClass('alert-info');
					$('strong', $alert).html "Success!" 
					$('span', $alert).html "The changes have been sucessfuly saved to the server."
					$alert.transition opacity: 0, delay: 3000, ->
						$alert.addClass 'invisible'
				.fail =>
					$alert = $('#submit-state').removeClass('alert-success').addClass('alert-warning').removeClass('alert-info');
					$('strong', $alert).html "Failed." 
					$('span', $alert).html "Could not save changes to the server."
					$alert.removeClass('invisible')
				
				.always => 	@$el.trigger 'loader', false 

				return false;
					
		
		winEvents:
			'resize': ->
				console.log "WordEditView window size changed: #{$(window).width()}x#{$(window).height()}"
				@$el.parent().height @$el.height()
#				@$el.width @$el.parent().width()
				return false;
		daoEvents:
			'dataChange; Word': (evt)->
				if evt.daoEvent.action == 'create'
					@word = new WordModel(evt.daoEvent.result)
					$('#word-id').html "##{@word.ID}"