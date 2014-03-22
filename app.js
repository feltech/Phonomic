// Generated by CoffeeScript 1.6.3
/*
 Debugger.
*/

var FCGI, app, captcha, exec, express, fcgi, fcgiSocket, hogan, http, lastIP, list, moment, net, path, port, routes, sys, template, user, word;

if (!process.argv[2]) {
  process.kill(process.pid, 'SIGUSR1');
  sys = require('sys');
  exec = require('child_process').exec;
  exec('node-inspector');
}

/*
 Module dependencies.
*/


express = require('express');

hogan = require('hogan.js');

template = require('./routes/template');

fcgi = require('connect-fastcgi');

net = require('net');

FCGI = require('fastcgi-stream');

fcgiSocket = net.connect(7000, 'localhost', function() {
  return console.log(JSON.stringify(arguments));
});

http = require('http');

path = require('path');

moment = require('moment');

captcha = require('captchagen');

routes = require('./routes');

user = require('./routes/user');

list = require('./routes/list');

word = require('./routes/word');

/*
 Init app.
*/


app = express();

port = process.argv[2] || process.env.PORT || 3000;

console.log("Using port " + port);

app.set('port', port);

app.set('views', __dirname + '/views');

app.set('view engine', 'hjs');

/*
 Configure request pipeline,
*/


app.use(express.logger('dev'));

if (app.get('env') === 'development') {
  app.use(express.errorHandler());
}

lastIP = "";

app.use(function(req, res, next) {
  if (req.ip !== lastIP) {
    lastIP = req.ip;
    console.log("\n\n#####################################################");
  }
  console.log("\n" + ((moment().format()).toString('yyyy-MM-dd')) + ": " + req.ip);
  return next();
});

app.use(express.favicon());

app.use(express.compress());

app.use(express.bodyParser());

app.use(express.cookieParser('your secret here'));

app.use(express.session());

app.use(function(req, res, next) {
  if (!req.session.isHuman) {
    console.log("Session humanity not verified.");
    if (req.session.captcha) {
      if (req.body.captcha === req.session.captcha) {
        req.session.isHuman = true;
        console.log("Captcha " + req.session.captcha + " correct, humanity verified.");
      } else {
        console.log("Captcha " + req.session.captcha + " incorrect (" + req.body.captcha + " sent), humanity uncertain.");
      }
    }
  } else {
    console.log("Session humanity verified.");
  }
  return next();
});

app.use(app.router);

app.use(express["static"](path.join(__dirname, 'public')));

app.use(function(req, res, next) {
  console.log("404 requesting " + req.url);
  res.status(404);
  if (req.accepts('html')) {
    res.render('layouts/404', {
      url: req.url
    });
    return;
  }
  if (req.accepts('json')) {
    res.send({
      error: 'Not found'
    });
    return;
  }
  return res.type('txt').send('Not found');
});

/*
 Route handlers.
*/


app.get('/', routes.index);

app.get('/users', user.list);

template.setDir(app.get('views'));

app.get("/js/templates/:fileName", template);

app.get('/list/:id', list);

app.get('/captcha', function(req, res, next) {
  var capt;
  if (req.session.isHuman) {
    return res.send("");
  } else {
    capt = captcha.generate();
    req.session.captcha = capt.text();
    console.log("Generating captcha: " + req.session.captcha);
    return res.send(capt.uri());
  }
});

app.post("/word/:verb", word);

app.get('/fcgi', fcgi({
  fastcgiPort: 7000,
  fastcgiHost: 'localhost',
  root: "./"
}));

app.get('/fcgis', function(req, res, next) {
  var fcgiStream;
  console.log("Sending to fcgi");
  fcgiStream = new FCGI.FastCGIStream(fcgiSocket);
  fcgiStream.on("record", function(requestId, record) {
    var c, str, _i, _len, _ref;
    console.log("RECOIRD: " + requestId + " = " + JSON.stringify(record));
    if (record.data) {
      str = "";
      _ref = record.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        str += String.fromCharCode(c);
      }
      return res.send(str);
    }
  });
  fcgiStream.writeRecord(6532, new FCGI.records.BeginRequest(FCGI.records.BeginRequest.roles.FILTER, FCGI.records.BeginRequest.flags.KEEP_CONN));
  return fcgiStream.writeRecord(6532, new FCGI.records.EndRequest());
});

/*
 Start server.
*/


http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
