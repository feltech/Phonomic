define([], function() {
  var logger, _level, _levelMap;
  _level = 'debug';
  _levelMap = {
    'trace': 0,
    'debug': 1,
    'log': 2,
    'warn': 3,
    'error': 3
  };
  logger = function(lvl) {
    return _levelMap[_level] <= _levelMap[lvl];
  };
  logger.setLevel = function(lvl) {
    if (lvl) {
      _level = lvl;
    }
    return _level;
  };
  return logger;
});
