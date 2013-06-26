deferred = require('jquery-deferred').Deferred
fs = require 'fs' 
hogan = require 'hogan.js' 

extn = "hjs"
templateCache = {}
dir = "."

template = (req, res)->
	fileName = req.params.fileName.substr(0, req.params.fileName.lastIndexOf(".js"))
	deferred (defer)=>	
		if templateCache[fileName]
			defer.resolve templateCache[fileName]
		else
			fs.readFile "#{dir}/partials/#{fileName}.#{extn}", encoding: 'utf8', (err, file)->
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
template.setDir = (_dir)->
	dir = _dir
	
module.exports = template