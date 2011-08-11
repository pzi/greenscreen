(function() {
  var GreenScreen;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  GreenScreen = {
    timeout: 5000,
    builds: [],
    buildsURL: '/builds.json',
    buildsContainerSelector: '#builds',
    buildsSelector: '.build',
    buildTimeSelector: 'span.build_time',
    playSounds: false,
    templatesURL: '/templates.json',
    init: function() {
      this.updateBuilds();
      return setInterval(this.updateBuilds(), 500);
    },
    updateBuilds: function() {
      return $.getJSON(this.buildsURL, __bind(function(builds) {
        this.builds = builds;
        return this.draw();
      }, this));
    },
    clearBuilds: function() {
      return this.builds = {};
    },
    draw: function() {
      $('ul').empty();
      $.each(this.builds, function(index, build) {});
      return this.resize();
    },
    resize: function() {
      var height, rows, windowHeight;
      windowHeight = window.innerHeight;
      rows = Math.ceil(this.builds.length / 4);
      height = Math.ceil(windowHeight / rows);
      return $(this.buildsSelector).height(height);
    },
    checkStatus: function() {
      var failure, success;
      success = false;
      failure = false;
      return $(buildsSelector).each(function(index, element) {
        var name, status;
        element = $(element);
        name = element.attr('data-name');
        return status = element.attr('data-status');
      });
    },
    enableSounds: function() {
      return this.playSounds = true;
    },
    disableSounds: function() {
      return this.playSounds = false;
    }
  };
  window['GreenScreen'] = GreenScreen;
  $(function() {
    GreenScreen.init();
    return $(window).resize(function() {
      return GreenScreen.resize();
    });
  });
}).call(this);
