window.builds = {};

var successSound = new buzz.sound( "/success", {
  formats: [ "mp3", "ogg", "wav" ]
});

var failSound = new buzz.sound( "/fail", {
  formats: [ "mp3", "ogg", "wav" ]
});

function watchBuildStatus() {
  var playSuccess = false, playFailure = false;

  $('.project').each(function(idx, element) {
    element = $(element);
    var name = element.attr('data-name'), status = element.attr('data-status');
    if (window.builds[name] && window.builds[name] != status) {
      if (status == 'success') {
        playSuccess = true;
      } else if (status == 'failure') {
        playFailure = true;
      }
    }

    window.builds[name] = status;
  });

  if (playFailure) {
    failSound.play();
  } else if (playSuccess) {
    successSound.play();
  }
}

setInterval(function() {
  $.get('/tenderstats', function(html) {
    $('#tender').html(html);
  });
}, (1000 * 60 * 60)); // udpate on the hour

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
