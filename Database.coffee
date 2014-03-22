# MySQL database connection and query library.
mysql = require('mysql');
# Promise implementation.
deferred = require('jquery-deferred').Deferred

instance = null

# Database wrapper utility class.
module.exports = class Database
	constructor: ->
		@db()
	# Create and store the connection.
	db: ->
		if (@connection?._socket?.readable && @connection?._socket?.writable)
			return @connection
		else			
			@connection = mysql.createConnection
				host: 'localhost'
				user: 'root'
				password: 'dave'
				database: 'phonetica'
			@connection.connect (err)->
				if (err)
					console.log "SQL CONNECT ERROR: #{err}"
				else
					console.log "SQL CONNECT SUCCESSFUL."				
			@connection.on "close", (err)->
				console.log "SQL CONNECTION CLOSED."
			@connection.on "error", (err)->
				console.log "SQL CONNECTION ERROR: #{err}"
			return @connection
	# Query the database with given sql and option attributes hash, using
	# the promise idiom for returning responses.
	query: (sql, attrs)->

		return deferred (defer)=>
			query = @db().query sql, attrs, (err, result)=>
				console.log if result then "#{result.length || JSON.stringify(result)} records found" else err
				if err then defer.reject(err) else defer.resolve(result)

		console.log "SQL QUERY: #{query.sql}"
			
	@Instance: ()->
		if instance then instance else instance = new Database()			
