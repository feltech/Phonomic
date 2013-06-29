define [
	'underscore',
	'jquery',
	'brite'
], (_, $, brite) ->
	class WordModel
		constructor: (attrs)->
			_.extend this, attrs
			@Languages = @Languages.split "\t" if @Languages
		entityType: ()->
			return 'WordModel'
		get: (id)->
		create: ()->
		remove: (id)->
		removeMany: (ids)->
		update: (data)->
		list: (text)->

			