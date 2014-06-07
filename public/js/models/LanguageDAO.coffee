define [
	'underscore',
	'jquery', 
	'brite',
	'models/WordModel'
], (_, $, brite, WordModel) ->
	updateFrequency = 3 * 60 * 60 * 1000
	P = -> $.Deferred().promise()

	class LanguageDAO
		_cache: []
		_updateDate: new Date 0
		
		constructor: ()->
		entityType: ()->
			return 'Language'
		get: (id)-> P().then => _(@_cache).findWhere( ID: id )
		create: ()->
		remove: (id)->
		removeMany: (ids)->
		update: (data)->
		list: (opts)->
			if !!opts?.server || ((new Date).getTime() - @_updateDate.getTime()) > updateFrequency
			 return $.getJSON('list/languages')
				.then (@_cache) =>
					return @_cache
				.fail (xhr)->
					$('#error-log').append xhr.responseText	
					
			else
				return @_cache
				
		cache: (attrs)->
			if attrs then _(this._cache).findWhere attrs else this._cache
