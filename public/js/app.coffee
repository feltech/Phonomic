define [
	'brite',
	'utils/logger',
	'views/MainView'	
], (brite, log, MainView) ->
	init: () ->
		log.setLevel 'trace'
		brite.display 'MainView', '#content'
		
		