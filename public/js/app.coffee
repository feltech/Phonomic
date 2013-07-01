define [
	'underscore',
	'underscore.string',
	'brite',
	'utils/logger',
	'models/LanguageDAO',
	'models/WordDAO',
	'views/MainView'	
], (_, _str, brite, log, LanguageDAO, WordDAO, MainView) ->
	init: () ->
		_.mixin(_str.exports())
		log.setLevel 'trace'
		brite.registerDao new LanguageDAO
		brite.registerDao new WordDAO
		brite.display 'MainView', '#content'
		
		