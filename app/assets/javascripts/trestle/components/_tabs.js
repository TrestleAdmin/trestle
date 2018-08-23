Trestle.init(function(e, root) {
  $(root).find("a[data-toggle='tab']").on('shown.bs.tab', function(e) {
    var hash = $(this).attr("href");
    var withinModal = $(this).closest('.modal').length > 0;

    if (hash.substr(0, 1) == "#" && !withinModal) {
      history.replaceState({ turbolinks: {} }, "", "#!" + hash.substr(1));
    }
  });
});

Trestle.focusActiveTab = function() {
  if (location.hash.substr(0, 2) == "#!") {
    // Focus on active tab from URL
    $("a[data-toggle='tab'][href='#" + location.hash.substr(2) + "']").tab("show");
  } else if ($(".tab-pane:has(.has-error)").length) {
    // Focus on first tab with errors
    var pane = $(".tab-pane:has(.has-error)").first();
    $("a[data-toggle='tab'][href='#" + pane.attr("id") + "']").tab("show");
  }
};

Trestle.init(function() {
  Trestle.focusActiveTab();
});
