(function() {
  var GreenScreen;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  GreenScreen = {
    timeout: 2000,
    builds: [],
    buildsURL: '/builds.json',
    init: function() {
      this.updateBuilds();
      return setInterval($.proxy(this.updateBuilds, this), this.timeout);
    },
    updateBuilds: function() {
      return $.getJSON(this.buildsURL, __bind(function(builds) {
        delete builds.unknown;
        this.builds = builds;
        return this.draw();
      }, this));
    },
    clearBuilds: function() {
      return this.builds = {};
    },
    buildItem: function(obj) {
      var item;
      item = $('<li>');
      item.text(obj.name);
      item.attr('title', obj.last_build_time);
      item.attr('data-id', obj.name);
      return item.attr('data-status', obj.last_build_status);
    },
    draw: function() {
      $('ul').empty();
      return $.each(this.builds, __bind(function(category, projects) {
        $("#" + category + " h1 .count").text(projects.length);
        return $.each(projects, __bind(function(index, project) {
          return $("#" + category + " ul").append(this.buildItem(project));
        }, this));
      }, this));
    }
  };
  window['GreenScreen'] = GreenScreen;
  $(function() {
    return GreenScreen.init();
  });
}).call(this);
