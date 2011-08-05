window.builds = {};

var successSound = new buzz.sound( "/success", {
  formats: [ "mp3", "ogg", "wav" ]
});

var failSound = new buzz.sound( "/fail", {
  formats: [ "mp3", "ogg", "wav" ]
});

function watchBuildStatus() {
  var successfull = false;
  var failure = false;

  $('.project').each(function(idx, element) {
    element = $(element);
    var name = element.attr('data-name'), status = element.attr('data-status');
    if (window.builds[name] && window.builds[name] != status) {
      if (status == 'success') {
        successfull = true;
      } else if (status == 'failure') {
        failure = true;
      }
    }

    window.builds[name] = status;
  });
}

setInterval(function() {
  $.get('/builds', function(html) {
    var updated = $(html);
    updated.find('span.build_time').timeago();
    $('#builds').html(updated);
    watchBuildStatus();
  });
}, 5000);

$(document).ready(function() {
  $("span.build_time").timeago();
});
