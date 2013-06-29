// Generated by CoffeeScript 1.6.3
define(['jquery', 'brite', 'views/WordSearchView', 'views/WordListView'], function($, brite) {
  return brite.registerView('MainView', {
    emptyParent: true
  }, {
    create: function() {
      return "<div>";
    },
    postDisplay: function() {
      brite.display('WordSearchView', this.$el);
      brite.display('WordListView', $('#right-panel'));
      return true;
    }
  });
});
