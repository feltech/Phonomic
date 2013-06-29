// Generated by CoffeeScript 1.6.3
/*
 Module dependencies.
*/

var WordListModel, app, deferred, exec, express, fs, hogan, http, list, path, routes, sys, template, user;

process.kill(process.pid, 'SIGUSR1');

sys = require('sys');

exec = require('child_process').exec;

exec('node-inspector');

express = require('express');

hogan = require('hogan.js');

routes = require('./routes');

user = require('./routes/user');

template = require('./routes/template');

list = require('./routes/list');

http = require('http');

path = require('path');

fs = require('fs');

deferred = require('jquery-deferred').Deferred;

WordListModel = require('./models/WordListModel');

app = express();

app.set('port', process.env.PORT || 3000);

app.set('views', __dirname + '/views');

app.set('view engine', 'hjs');

app.use(express.favicon());

app.use(express.logger('dev'));

app.use(express.compress());

app.use(express.bodyParser());

app.use(express.cookieParser('your secret here'));

app.use(express.session());

app.use(app.router);

app.use(express["static"](path.join(__dirname, 'public')));

if (app.get('env') === 'development') {
  app.use(express.errorHandler());
}

app.get('/', routes.index);

app.get('/users', user.list);

template.setDir(app.get('views'));

app.get("/js/templates/:fileName", template);

app.get('/list/:id', list);

app.post("/search", function(req, res) {
  var model;
  model = new WordListModel();
  return model.list(req.body.field, req.body.value).done(function(json) {
    return res.send(json);
  });
});

http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
