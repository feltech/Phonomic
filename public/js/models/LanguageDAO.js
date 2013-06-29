// Generated by CoffeeScript 1.6.3
define(['underscore', 'jquery', 'brite', 'models/WordModel'], function(_, $, brite, WordModel) {
  var LanguageDAO, updateFrequency;
  updateFrequency = 3 * 60 * 60 * 1000;
  return LanguageDAO = (function() {
    LanguageDAO.prototype._cache = [];

    LanguageDAO.prototype._updateDate = new Date(0);

    function LanguageDAO() {}

    LanguageDAO.prototype.entityType = function() {
      return 'Language';
    };

    LanguageDAO.prototype.get = function(id) {};

    LanguageDAO.prototype.create = function() {};

    LanguageDAO.prototype.remove = function(id) {};

    LanguageDAO.prototype.removeMany = function(ids) {};

    LanguageDAO.prototype.update = function(data) {};

    LanguageDAO.prototype.list = function(opts) {
      var _this = this;
      if (!!(opts != null ? opts.server : void 0) || (new Date).getTime() - this._updateDate.getTime() > updateFrequency) {
        return $.getJSON('list/languages').then(function(_cache) {
          _this._cache = _cache;
          return _this._cache;
        }).fail(function(xhr) {
          return $('#error-log').append(xhr.responseText);
        });
      } else {
        return this._cache;
      }
    };

    LanguageDAO.prototype.cache = function(attrs) {
      if (attrs) {
        return _(this._cache).findWhere(attrs);
      } else {
        return this._cache;
      }
    };

    return LanguageDAO;

  })();
});
