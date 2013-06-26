// Generated by CoffeeScript 1.6.3
define(['underscore', 'jquery', 'brite', 'templates/WordSearch', 'templates/WordSearchList', 'utils/logger', 'models/WordSearchModel', 'views/WordEditView', 'lib/jquery/jquery.transit'], function(underscore, $, brite, searchTmpl, listTmpl, log, WordSearchModel, WordEditView) {
  return brite.registerView('WordSearch', {
    create: function() {
      this.model = brite.registerDao(new WordSearchModel);
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
          text: text
        });
        return false;
      },
      'click; #word-list > li': function(evt) {
        var wordRef;
        wordRef = $(evt.currentTarget).bEntity('Word');
        this.$el.trigger('edit', {
          id: parseInt(wordRef.id, 10)
        });
        return false;
      }
    },
    docEvents: {
      'search': function(evt, data) {
        return this.model.list(data.text).fail(function(xhr) {
          return $('#error-log').append(xhr.responseText);
        });
      },
      'edit': function(evt, data) {
        $('#word-edit', this.$el).bEmpty();
        return this.model.cache({
          ID: data.id
        }).done(function(word) {
          return brite.display('WordEditView', $('#word-edit', this.$el), word);
        });
      }
    },
    daoEvents: {
      'result; WordSearchModel': function(evt) {
        if (evt.daoEvent.action === 'list') {
          $('#right-panel').hide().html(listTmpl.render({
            words: evt.daoEvent.result
          })).css({
            x: $(window).width()
          }).show().transition({
            x: 0
          }, 300, 'snap');
        }
        if (log('debug')) {
          console.debug(JSON.stringify(evt.daoEvent));
        }
      }
    }
  });
});
