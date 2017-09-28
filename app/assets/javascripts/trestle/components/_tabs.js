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
    // Focus on active tab from URL
    $("a[data-toggle='tab'][href='#" + location.hash.substr(2) + "']").tab("show");
  } else if ($(".tab-pane:has(.has-error)").length) {
    // Focus on first tab with errors
    var pane = $(".tab-pane:has(.has-error)").first();
    $("a[data-toggle='tab'][href='#" + pane.attr("id") + "']").tab("show");
  }
});
