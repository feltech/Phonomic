# MySQL database connection and query library.
mysql = require('mysql');
# Promise implementation.
deferred = require('jquery-deferred').Deferred

# Database wrapper utility class.
module.exports = class Database
	constructor: ()->
		# Create and store the connection.
		@connection = mysql.createConnection
				host: 'localhost'
				user: 'root'
				password: 'dave'
				database: 'phonetica'
	# Query the database with given sql and option attributes hash, using
	# the promise idiom for returning responses.
	query: (sql, attrs)->
		defer = deferred()
		query = @connection.query sql, attrs, (err, result)=>
			console.log if result then "#{result.length} records found" else err
			if err then defer.reject(err) else defer.resolve(result)
		console.log(query.sql);
		return defer
			
# Create singleton database handler.
instance = null
Database.Instance = ()->
	if instance then instance else instance = new Database()