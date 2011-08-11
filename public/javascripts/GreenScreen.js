(function() {
  var GreenScreen;
  GreenScreen = {
    timeout: 5000,
    builds: {},
    buildsURL: '/builds',
    buildsContainerSelector: '#builds',
    buildsSelector: '.project',
    buildTimeSelector: 'span.build_time',
    playSounds: false,
    init: function() {
      return $.setInterval(updateBuilds, timeout);
    },
    updateBuilds: function() {
      return $.get(buildsURL, draw);
    },
    drawBuilds: function(html) {
      var builds;
      builds = $(html);
      builds.find(buildTimeSelector).timeago();
      $(buildsContainerSelector).html(builds);
      return checkBuildStatus();
    },
    clearBuilds: function() {
      return this.builds = {};
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
  GreenScreen.Build = {};
  window['GreenScreen'] = GreenScreen;
  $(function() {
    return GreenScreen.init();
  });
}).call(this);
