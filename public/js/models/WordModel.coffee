define [
	'underscore',
	'jquery',
	'brite'
], (_, $, brite) ->
	class WordModel
		constructor: (attrs)->
			_.extend this, attrs
		entityType: ()->
			return 'WordModel'
		get: (id)->
			if id then @attrs[id] else @attrs