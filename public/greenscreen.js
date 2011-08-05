setInterval(function() {
  $.get('/builds', function(html) {
    var updated = $(html);
    updated.find('span.build_time').timeago();
    $('#builds').html(updated);
  });
}, 1000);

$(document).ready(function() {
  $("span.build_time").timeago();
});
