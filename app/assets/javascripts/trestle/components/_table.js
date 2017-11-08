$(document).on('click', 'tr[data-url]:not([data-behavior="dialog"])', function(e) {
  var row = $(e.currentTarget);

  if (row.data('url') == 'auto') {
    var url = row.find('td:not(.actions) a:first').attr('href');
  } else {
    var url = row.data('url');
  }

  if (url) {
    if (e.metaKey || e.ctrlKey) {
      window.open(url, '_blank');
    } else {
      Trestle.visit(url);
    }
  }
});

$(document).on('click', 'tr[data-url] a', function(e) {
  e.stopPropagation();
});
