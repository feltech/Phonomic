// Generated by CoffeeScript 1.6.3
var Database, deferred, instance, isRetry, mysql;

mysql = require('mysql');

deferred = require('jquery-deferred').Deferred;

isRetry = false;

instance = null;

module.exports = Database = (function() {
  function Database() {}

  Database.prototype.query = function(sql, attrs) {
    var connection,
      _this = this;
    connection = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'dave',
      database: 'phonetica'
    });
    return deferred(function(defer) {
      var e, query;
      try {
        query = connection.query(sql, attrs, function(err, result) {
          console.log(result ? "" + result.length + " records found" : err);
          if (err) {
            return defer.reject(err);
          } else {
            return defer.resolve(result);
          }
        });
        isRetry = false;
        return console.log("Database. " + query.sql);
      } catch (_error) {
        e = _error;
        if (!isRetry) {
          console.warn("WARN: Database query failed, retrying. " + query.sql + " :: " + e.message + " :: " + e.stack);
          isRetry = true;
          instance = null;
          return Database.Instance().query(sql, attrs);
        } else {
          return console.error("ERROR: Database query failed, retry failed. " + query.sql + " :: " + e.message + " :: " + e.stack);
        }
      }
    });
  };

  Database.Instance = function() {
    if (instance) {
      return instance;
    } else {
      return instance = new Database();
    }
  };

  return Database;

})();
