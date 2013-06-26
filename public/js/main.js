// Generated by CoffeeScript 1.6.3
requirejs.config({
  baseUrl: "js/",
  paths: {
    'brite': 'lib/brite',
    'jquery': 'lib/jquery/jquery',
    'hogan': 'lib/hogan',
    'underscore': 'lib/underscore/underscore'
  },
  shim: {
    'brite': {
      exports: 'brite',
      deps: ['jquery']
    },
    'lib/jquery/jquery.transit': ['jquery'],
    'hogan': {
      exports: 'Hogan'
    },
    'underscore': {
      exports: '_'
    }
  }
});

requirejs(['app'], function(app) {
  return $(document).ready(function() {
    return app.init();
  });
});
