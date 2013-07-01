// Generated by CoffeeScript 1.6.3
define(['underscore', 'jquery', 'brite', 'templates/WordSearch', 'utils/logger', 'models/WordModel', 'views/WordEditView', 'views/WordListView', 'lib/jquery/jquery.transit'], function(underscore, $, brite, searchTmpl, log, WordModel) {
  var transitTime;
  transitTime = 500;
  return brite.registerView('WordSearchView', {
    create: function() {
      return searchTmpl.render();
    },
    events: {
      'submit; #form-search': function(evt) {
        var $target, text;
        evt.preventDefault();
        $target = $(evt.currentTarget);
        $('#error-log').bEmpty();
        text = $('input', $target).val();
        this.$el.trigger('search', {
          field: 'Native',
          text: text
        });
        return false;
      },
      'click; button#new-word': function(evt) {
        var $target, text;
        $target = $(evt.currentTarget);
        text = $('#form-search > input').val();
        return this.$el.trigger('create', {
          Native: text
        });
      }
    },
    postDisplay: function() {
      if (log('trace')) {
        console.debug("WordSearchView.postDisplay");
      }
    },
    docEvents: {
      'edit': function(evt, data) {
        var _this = this;
        return this.hideEditView().then(function() {
          return brite.display('WordEditView', $('#word-edit'), data.word).done(function(editView) {
            _this.editView = editView;
          });
        });
      },
      'create': function(evt, data) {
        var _this = this;
        return this.hideEditView().then(function() {
          return brite.display('WordEditView', $('#word-edit'), new WordModel(data)).done(function(editView) {
            _this.editView = editView;
          });
        });
      }
    },
    daoEvents: {},
    hideEditView: function() {
      var _this = this;
      return $.Deferred().resolve().then(function() {
        if (_this.editView) {
          return _this.editView.hide().then(function($el) {
            return $el != null ? $el.bEmpty().remove() : void 0;
          });
        }
      });
    }
  });
});
