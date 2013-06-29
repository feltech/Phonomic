// Generated by CoffeeScript 1.6.3
define(['underscore', 'jquery', 'brite', 'templates/WordSearch', 'utils/logger', 'views/WordEditView', 'views/WordListView', 'lib/jquery/jquery.transit'], function(underscore, $, brite, searchTmpl, log) {
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
          field: 'Roman',
          text: text
        });
        return false;
      }
    },
    postDisplay: function() {
      if (log('trace')) {
        console.debug("WordSearchView.postDisplay");
      }
    },
    docEvents: {
      'edit': function(evt, data) {
        var _ref,
          _this = this;
        if ((_ref = this.editView) != null) {
          _ref.hide().done(function($el) {
            return $el.bEmpty().remove();
          });
        }
        return brite.display('WordEditView', $('#word-edit'), data.word).done(function(editView) {
          _this.editView = editView;
          return $('#word-edit', _this.$el).height(_this.editView.$el.height());
        });
      }
    },
    daoEvents: {}
  });
});
