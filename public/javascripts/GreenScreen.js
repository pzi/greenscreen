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
        if (this.builds.length === 0) {
          this.builds = builds;
          return this.draw();
        } else {
          this.builds = builds;
          return this.refresh();
        }
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
      return item.attr('data-status', obj.status);
    },
    draw: function() {
      $('ul').empty();
      return $.each(this.builds, __bind(function(category, projects) {
        $("#" + category + " h1 .count").text(projects.length);
        return $.each(projects, __bind(function(index, project) {
          return $("#" + category + " ul").append(this.buildItem(project));
        }, this));
      }, this));
    },
    refresh: function() {
      return $.each(this.builds, __bind(function(category, projects) {
        return $.each(projects, __bind(function(index, project) {
          var currentBuild, newBuild;
          currentBuild = $("li[data-id='" + project.name + "']");
          newBuild = this.buildItem(project);
          if (currentBuild.attr('data-status') !== newBuild.attr('data-status')) {
            return currentBuild.fadeOut(500, __bind(function() {
              currentBuild.remove();
              newBuild.hide();
              $("#" + category + " ul").append(newBuild);
              newBuild.fadeIn(500);
              return this.updateCounts();
            }, this));
          }
        }, this));
      }, this));
    },
    updateCounts: function() {
      return $('ul').each(function() {
        var count, header, list;
        list = $(this);
        count = list.find('li').length;
        header = list.siblings('h1:first').find('.count');
        return header.text(count);
      });
    }
  };
  window['GreenScreen'] = GreenScreen;
  $(function() {
    return GreenScreen.init();
  });
}).call(this);
