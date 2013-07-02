define [
	'underscore',
	'jquery',
	'brite'
], (_, $, brite) ->
	class WordModel
		Languages: ""
		Roman: ""
		Native: ""
		Phonetic: ""
		constructor: (attrs)->
			_.extend this, attrs
		get: (id)->
			if id then @attrs[id] else @attrs