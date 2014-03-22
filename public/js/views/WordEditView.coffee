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
			@alertCount = 0
			# Create clone of word data to mutate for rendering.
			wordRender = _.clone @word
			# Get language data to expand word languages for rendering.
			return brite.dao("Language").list().then (languages)=>
				# Parse list of IDs of languages in Language table that this word references.
				languageIDs = _.compact word.Languages?.split '\t'
				languageIDs = _(languageIDs).map (id)-> parseInt(id)
				# Replace list of language IDs with actual language objects.
				wordRender.Languages = _(languageIDs).map (id)-> _(languages).findWhere(ID: id)
				# 
				return $.get('/captcha').then (data)-> captcha: data, languages: languages
			.then (data)->	
				return editTmpl.render { word: wordRender, languages: data.languages, captcha: data.captcha || undefined }, langList: langTmpl
		init: ->
			@$el.hide()
			return
		destroy: ->
			@$el.parent().height('auto')
			
		postDisplay: ->
			sourceY = $(window).height() + $(window).scrollTop() + @$el.parent().height()
			console.log "WordEditView transitioning from y=#{sourceY}" if log('trace')
			@$el.parent().height @$el.height()
			return $.Deferred (defer)=>
				@$el.css(y: sourceY, opacity: 0.5)
					.show()
					.transition y: 0, opacity: 1, transitTime, 'snap', ->
						defer.resolve()
			.done =>
				offset = Math.max(@$el.offset().top - 100, 0)
				$('html, body').animate(scrollTop: "#{offset}px",'slow')
		
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
		
		showAlert: (type, title, text)->
			$alert = $('#submit-state')
			@alertCount++
			@resetAlert().then ->
				$alert.addClass "alert-#{type}" 
				$('strong', $alert).html title
				$('span', $alert).html text
				$alert.removeClass('invisible')
				
		resetAlert: (delay)->
			$alert = $('#submit-state')
			alertCount = @alertCount
			defer = $.Deferred().resolve()
			if delay
				defer = defer.then => $.Deferred (defer) => _.delay =>
					if $alert.is('.invisible') or alertCount != @alertCount
						defer.reject()
					else 
						defer.resolve()
				, delay
			return defer.then -> 
				$alert.addClass('invisible').removeClass('alert-success').removeClass('alert-warning').removeClass('alert-info')
			, ->
				$.Deferred().resolve()
			.promise()
				
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
					captcha: $('#captcha').val()
					
				@$el.trigger 'loader', true 
				@showAlert('info', "Sending.", "The changes are being sent to the server, please wait...").then =>				
					return brite.dao('Word')[if @word.ID then 'update' else 'create'](@word)				
				.then =>
					return @showAlert('success', "Success!", "The changes have been sucessfuly saved to the server.")		
				.always => 
					@$el.trigger 'loader', false 
					
				.then =>
					return @resetAlert(5000)
									
				.fail (xhr, error, text) =>

					return @showAlert 'warning', "Failed.", 
						if xhr.status == 401 
							"Sorry, the text you entered does not match the captcha text above, please try again." 
						else
							"A server error occurred whilst trying to save your changes."


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