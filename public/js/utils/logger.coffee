define [
], ()->
	_level = 'debug'
	_levelMap = 
		'trace': 0
		'debug': 1
		'log': 2
		'warn': 3
		'error': 3
	logger = (lvl)->
		return _levelMap[_level] <= _levelMap[lvl]	
	logger.setLevel = (lvl)->
		_level = lvl if lvl
		return _level 
	return logger