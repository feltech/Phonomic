
###
 Module dependencies.
###
process.kill(process.pid, 'SIGUSR1');
sys = require('sys')
exec = require('child_process').exec;
exec('node-inspector')

express = require 'express'
hjs = require 'hjs'
hogan = require 'hogan.js'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path'
fs = require 'fs'
deferred = require('jquery-deferred').Deferred

WordListModel = require './models/WordListModel'
templateCache = {}

app = express()
# all environments
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'hjs')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.compress())
app.use(express.bodyParser())
#app.use(express.methodOverride())
app.use(express.cookieParser('your secret here'))
app.use(express.session())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))

# development only
if app.get('env') is 'development' then app.use express.errorHandler()

app.get '/', routes.index
app.get '/users', user.list
app.get "/js/template/:fileName", (req, res, next)->
	fileName = req.params.fileName.substr(0, req.params.fileName.lastIndexOf(".js"))
	deferred (defer)->	
		if templateCache[fileName]
			defer.resolve templateCache[fileName]
		else
			fs.readFile "#{app.get('views')}/partials/#{fileName}.hjs", encoding: 'utf8', (err, file)->
				if err then defer.reject err
				else templateCache[fileName] = """
					define(['hogan'], function (Hogan) {
						return new Hogan.Template(#{hogan.compile(file, asString: true)});
					});"""
				defer.resolve templateCache[fileName]
	.done (tmpl)->
		res.contentType('.js')
		res.send(tmpl)
	.fail (err)->
		throw err


app.post "/search", (req, res)->
	model = new WordListModel()
	model.list(req.body.text).done (json)->
		res.send json



http.createServer(app).listen app.get('port'), ()->
	console.log('Express server listening on port ' + app.get('port'))
