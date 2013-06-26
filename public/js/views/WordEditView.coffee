define [
	'jquery', 
	'brite',
	'templates/WordEdit',
	'utils/logger'
], ($, brite, editTmpl, log) ->

	brite.registerView 'WordEditView',
		create: (word)->
			@dao = brite.registerDao word
			@model = word
			
			return editTmpl.render word: @model
		events:	{}
				
		docEvents: {}

		daoEvents: {}
				