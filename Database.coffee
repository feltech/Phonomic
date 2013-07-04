# MySQL database connection and query library.
mysql = require('mysql');
# Promise implementation.
deferred = require('jquery-deferred').Deferred

isRetry = false
instance = null

# Database wrapper utility class.
module.exports = class Database
	constructor: ()->
		# Create and store the connection.
	# Query the database with given sql and option attributes hash, using
	# the promise idiom for returning responses.
	query: (sql, attrs)->
		connection = mysql.createConnection
				host: 'localhost'
				user: 'root'
				password: 'dave'
				database: 'phonetica'
	
		return deferred (defer)=>
			try
				query = connection.query sql, attrs, (err, result)=>
					console.log if result then "#{result.length} records found" else err
					if err then defer.reject(err) else defer.resolve(result)
				isRetry = false
				console.log "Database. #{query.sql}"
			catch e
				if not isRetry
					console.warn "WARN: Database query failed, retrying. #{query.sql} :: #{e.message} :: #{e.stack}"
					isRetry = true
					instance = null
					Database.Instance().query(sql, attrs)
				else
					console.error "ERROR: Database query failed, retry failed. #{query.sql} :: #{e.message} :: #{e.stack}"
			
	@Instance: ()->
		if instance then instance else instance = new Database()			
			
			
