###
 Debugger.
###
process.kill(process.pid, 'SIGUSR1');
sys = require('sys')
exec = require('child_process').exec;
exec('node-inspector')

###
 Module dependencies.
###
# Framework
express = require 'express'
hogan = require 'hogan.js'
template = require './routes/template'
# System
http = require 'http'
path = require 'path'
moment = require 'moment'
# Routing.
routes = require './routes'
user = require './routes/user'
list = require './routes/list'
word = require './routes/word'

###
 Init app.
###
app = express()
app.set('port', process.env.PORT || 80)
app.set('views', __dirname + '/views')
app.set('view engine', 'hjs')

###
 Configure request pipeline,
###
app.use(express.logger('dev'))
if app.get('env') is 'development'
	app.use express.errorHandler()
app.use (req, res, next)->
	console.log "#{(moment().format()).toString 'yyyy-MM-dd'}: #{req.ip}"
	next()
app.use(express.favicon())
app.use(express.compress())
app.use(express.bodyParser())
#app.use(express.methodOverride())
app.use(express.cookieParser('your secret here'))
app.use(express.session())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))
app.use (req, res, next)->
	console.log "404 requesting #{req.url}"
	res.status(404);

	if (req.accepts('html'))
		res.render 'layouts/404', url: req.url
		return;

	if (req.accepts('json'))
		res.send error: 'Not found' 
		return;


	res.type('txt').send 'Not found'


###
 Route handlers.
###
app.get '/', routes.index
app.get '/users', user.list
template.setDir app.get('views')
app.get "/js/templates/:fileName", template
app.get '/list/:id', list
app.post "/word/:verb", word

###
 Start server.
###
http.createServer(app).listen app.get('port'), ()->
	console.log('Express server listening on port ' + app.get('port'))
