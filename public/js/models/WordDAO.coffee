define [
	'underscore',
	'jquery', 
	'brite',
	'models/WordModel'
], (_, $, brite, WordModel) ->
	class WordDAO
		_cache: []
	
		constructor: ()->
		entityType: ()->
			return 'Word'
		get: (id)->
		create: (data)->
			$('#error-log').empty()
			if data instanceof WordModel
				return $.post("word/create", data, null, "json")
				.then (data)=>
					if data
						word = _(@_cache).findWhere(ID: data?.ID)
						if word 
							_(word).extend data
						else
							word = new WordModel(data)
							@_cache.push word

					return word || $.Deferred.reject();
				.fail (xhr)->
					$('#error-log').append xhr.responseText
			else return $.Deferred().reject()			
		remove: (id)->
		removeMany: (ids)->
		update: (data)->	
			$('#error-log').empty()
			if data instanceof WordModel
				return $.post("word/update", data, null, "json")
				.then (data)=>
					if data
						word = _(@_cache).findWhere(ID: data?.ID)
						if word 
							_(word).extend data
						else
							word = new WordModel(data)
							@_cache.push word

					return word || $.Deferred.reject();
				.fail (xhr)->
					$('#error-log').append xhr.responseText
			else return $.Deferred().reject()
				
		list: (field, value)->
			value = escape(value)
			$('#error-log').empty()
			return $.post 'word/search', 
					field: field, value: value, 
					() -> # - empty function required to force jquery to use 4th (dataType) parameter and auto-parse response as json.
						return
					, 'json' 
				.then (data)=>
					@_cache = []
					@_cache.push(new WordModel(attrs)) for attrs in data
					return @_cache
				.fail (xhr)->
					$('#error-log').append xhr.responseText	

		cache: (attrs)->
			if attrs then _(this._cache).findWhere attrs else this._cache

#/**
# * DAO Interface. Return value directly since it is in memory.
# * @param {String} objectType
# * @param {Integer} id
# * @return the entity
# */
#MyDaoHandler.prototype.get = function(id){...
#
#/**
# * DAO Interface: Create new object, set new id, and add it.
# *
# * @param {String} objectType
# * @param {Object} newEntity if null, does nothing
# */
#MyDaoHandler.prototype.create = function(newEntity) {..
#
#/**
# * DAO Interface: remove an instance of objectType for a given type and id.
# *
# * Return the id deleted
# *
# * @param {String} objectType
# * @param {Integer} id
# *
# */
#MyMemoryDaoHandler.prototype.remove = function(id) {...
#
#/**
# * Additional methods to remove multiple items
# * 
# * @param {Array} ids. Array of entities id that needs to be removed 
# * 
# * @return the array of ids that have been removed
# */
#MyMemoryDaoHandler.prototype.removeMany = function(ids){..
#
#/**
# * DAO Interface: update a existing id with a set of property/value data.
# *
# * The DAO resolve with the updated data.
# *
# * @param {String} objectType
# * @param {Object} data Object containing the id and the properties to be updated
# *
# * Return the new object data
# */
#MyDaoHandler.prototype.update = function(data){...
#
#
#/**
# * DAO Interface: Return a deferred object for this objectType and options
# * @param {String} objectType
# * @param {Object} opts
# *           opts.pageIndex {Number} Index of the page, starting at 0.
# *           opts.pageSize  {Number} Size of the page
# *           opts.match     {Object} Object of matching items. If item is a single value, then, it is a ===, otherwise, it does an operation
# *                                        {prop:"name",op:"contains",val:"nana"} (will match an result like {name:"banana"})
# *           opts.orderBy   {String}
# *           opts.orderType {String} "asc" or "desc"
# */
#MyDaoHandler.prototype.list = function(opts){...
