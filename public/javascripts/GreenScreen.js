(function() {
  var GreenScreen;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  GreenScreen = {
    timeout: 2000,
    builds: [],
    buildsURL: '/builds.json',
    counts: {
      'successes': 0,
      'failures': 0,
      'building': 0,
      'total': 0
    },
    sounds: {
      enabled: true,
      success: new buzz.sound('/sounds/success', {
        formats: ['mp3', 'ogg', 'wav']
      }),
      failure: new buzz.sound('/sounds/fail', {
        formats: ['mp3', 'ogg', 'wav']
      })
    },
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
        $.each(projects, __bind(function(index, project) {
          return $("#" + category + " ul").append(this.buildItem(project));
        }, this));
        this.updateCounts();
        return this.checkForBuilding();
      }, this));
    },
    getSuccesses: function() {
      return $('#success ul li');
    },
    getFailures: function() {
      return $('#failure ul li');
    },
    getBuilding: function() {
      return $('#building ul li');
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
              if (this.sounds.enabled) {
                this.playSounds();
              } else {
                this.updateCounts();
              }
              return this.checkForBuilding();
            }, this));
          }
        }, this));
      }, this));
    },
    checkForBuilding: function() {
      var header;
      header = $('#building h1');
      if (this.getBuilding.length > 0) {
        return header.removeClass('pulse');
      } else {
        return header.addClass('pulse');
      }
    },
    updateCounts: function() {
      $('ul').each(function() {
        var count, header, list;
        list = $(this);
        count = list.find('li').length;
        header = list.siblings('h1:first').find('.count');
        return header.text(count);
      });
      this.counts.successes = this.getSuccesses().length;
      this.counts.failures = this.getFailures().length;
      this.counts.building = this.getBuilding().length;
      return this.counts.total = this.counts.successes + this.counts.failures + this.counts.building;
    },
    playSounds: function() {
      var oldCounts;
      oldCounts = this.counts;
      this.updateCounts();
      if (oldCounts.total === this.counts.total) {
        if (oldCounts.successes < this.counts.successes) {
          this.sounds.success.play();
        }
        if (oldCounts.failures < this.counts.failures) {
          return this.sounds.failures.play();
        }
      }
    }
  };
  window['GreenScreen'] = GreenScreen;
  $(function() {
    return GreenScreen.init();
  });
}).call(this);
