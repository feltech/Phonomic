define [
	'brite',
	'utils/logger',
	'models/LanguageDAO',
	'models/WordDAO',
	'views/MainView'	
], (brite, log, LanguageDAO, WordDAO, MainView) ->
	init: () ->
		log.setLevel 'trace'
		brite.registerDao new LanguageDAO
		brite.registerDao new WordDAO
		brite.display 'MainView', '#content'
		
		