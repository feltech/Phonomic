var Database, deferred, instance, mysql;

mysql = require('mysql');

deferred = require('jquery-deferred').Deferred;

instance = null;

module.exports = Database = (function() {
  function Database() {
    this.db();
  }

  Database.prototype.db = function() {
    var _ref, _ref1, _ref2, _ref3;
    if (((_ref = this.connection) != null ? (_ref1 = _ref._socket) != null ? _ref1.readable : void 0 : void 0) && ((_ref2 = this.connection) != null ? (_ref3 = _ref2._socket) != null ? _ref3.writable : void 0 : void 0)) {
      return this.connection;
    } else {
      this.connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'dave',
        database: 'phonetica'
      });
      this.connection.connect(function(err) {
        if (err) {
          return console.log("SQL CONNECT ERROR: " + err);
        } else {
          return console.log("SQL CONNECT SUCCESSFUL.");
        }
      });
      this.connection.on("close", function(err) {
        return console.log("SQL CONNECTION CLOSED.");
      });
      this.connection.on("error", function(err) {
        return console.log("SQL CONNECTION ERROR: " + err);
      });
      return this.connection;
    }
  };

  Database.prototype.query = function(sql, attrs) {
    var _this = this;
    return deferred(function(defer) {
      var query;
      return query = _this.db().query(sql, attrs, function(err, result) {
        console.log(result ? "" + (result.length || JSON.stringify(result)) + " records found" : err);
        if (err) {
          return defer.reject(err);
        } else {
          return defer.resolve(result);
        }
      });
    });
    return console.log("SQL QUERY: " + query.sql);
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
