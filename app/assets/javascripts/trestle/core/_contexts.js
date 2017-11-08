Trestle.refreshContext = function(context) {
  var url = context.data('context');

  $.get(url, function(data) {
    context.html(data);
    $(Trestle).trigger('init', context);
  });
};

Trestle.refreshMainContext = function() {
  var context = $('.app-main[data-context]');
  Trestle.refreshContext(context);
};
