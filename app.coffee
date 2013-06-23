
###
 Module dependencies.
###

express = require 'express'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path'
HoganCompiler = require 'hogan-template-compiler'

WordListModel = require './models/WordListModel'

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

hoganCompiler = HoganCompiler(partialsDirectory: "#{app.get('views')}/partials/", layoutsDirectory:  "#{app.get('views')}/layouts/")

app.get '/', routes.index
app.get '/users', user.list
app.get "/js/templates.js", (req, res)->
    res.contentType ".js"
    res.send hoganCompiler.getSharedTemplates()
app.post "/search", (req, res)->
	model = new WordListModel()
	model.list(req.body.text).done (json)->
		res.send json



http.createServer(app).listen app.get('port'), ()->
	console.log('Express server listening on port ' + app.get('port'))
