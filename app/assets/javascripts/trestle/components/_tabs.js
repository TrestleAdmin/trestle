Trestle.init(function(e, root) {
  $(root).find("a[data-toggle='tab']").on('shown.bs.tab', function(e) {
    var hash = $(this).attr("href");

    if (hash.substr(0, 1) == "#") {
      history.replaceState({ turbolinks: {} }, "", "#!" + hash.substr(1));
    }
  });
});

Trestle.ready(function() {
  if (location.hash.substr(0, 2) == "#!") {
    $("a[data-toggle='tab'][href='#" + location.hash.substr(2) + "']").tab("show");
  }
});
