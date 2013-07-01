deferred = require('jquery-deferred').Deferred
Database = require '../Database' 
squel = require 'squel'

list = (req, res)->
	switch req.params.id
		when 'languages'
			sql = squel.select().from('Languages').order('Name').toString()
			return Database.Instance().query(sql)
				.done (result)->
					res.contentType('.js')
					console.log "list languages complete"
					res.send(result)
				.fail (err)->
					throw err

module.exports = list