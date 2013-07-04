deferred = require('jquery-deferred').Deferred
Database = require '../Database' 
WordDAO = require('../models/WordDAO');
squel = require 'squel'

dao = new WordDAO()

wordRoute = (req, res, next)->
	console.log "Word attempting #{req.params.verb}"
	switch req.params.verb
		when 'search'
			dao.list(req.body.field, req.body.value).done (json)->
				res.send json

		when 'create'
			deferred (defer)->
				if req.session.isHuman then defer.resolve() else defer.reject(401)	
			.then -> 
				return dao.create(req.body)
			.done (word)->
				res.contentType('.js')
				console.log "create word #{req.body.Roman} complete. New ID=#{word.ID}"
				res.send(word)
			.fail ->
				console.log "Word create failed. human=#{req.session.isHuman}"
				res.send(401)

		when 'update'
			deferred (defer)->	
				if req.session.isHuman then defer.resolve() else defer.reject(401)	
			.then -> 
				return dao.update(req.body)
			.done (word)->
				res.contentType('.js')
				console.log "update word #{req.body.Roman} complete"
				res.send(word)
			.fail (errCode)->
				console.log "Word update failed. human=#{req.session.isHuman}"
				res.send(errCode || 500)
		else
			next()

module.exports = wordRoute