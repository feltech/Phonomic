deferred = require('jquery-deferred').Deferred
Database = require '../Database' 
WordDAO = require('../models/WordDAO');
squel = require 'squel'

dao = new WordDAO()

wordRoute = (req, res, next)->
	switch req.params.verb
		when 'search'
			dao.list(req.body.field, req.body.value).done (json)->
				res.send json
	
		when 'create'
			dao.create(req.body)
				.done (word)->
					res.contentType('.js')
					console.log "create word #{req.body.Roman} complete. New ID=#{word.ID}"
					res.send(word)
				.fail (err)->
					throw err
		when 'update'
			dao.update(req.body)
				.done (word)->
					res.contentType('.js')
					console.log "update word #{req.body.Roman} complete"
					res.send(word)
				.fail (err)->
					throw err
		else
			next()

module.exports = wordRoute