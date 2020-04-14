import $ from 'jquery'

import visit from '../core/visit'

// Allow clicking on any part of a table row to follow either the table's data-url
// or the first link within the row (that is not in the actions column).
$(document).on('click', 'tr[data-url]:not([data-behavior="dialog"])', function (e) {
  let row = $(e.currentTarget)

  let url

  if (row.data('url') === 'auto') {
    url = row.find('td:not(.actions) a:first').attr('href')
  } else {
    url = row.data('url')
  }

  if (url) {
    if (e.metaKey || e.ctrlKey) {
      window.open(url, '_blank')
    } else {
      visit(url)
    }
  }
})

$(document).on('click', 'th.select-row input', function(e) {

  if ($(this).is(':checked')) {

    $('td.select-row input').prop('checked', true);

  } else {

    $('td.select-row input').prop('checked', false);

  }

});

// Manage single row selection to update master row status
$(document).on('click', 'td.select-row input', function(e) {

  var total_check_boxes = $("td.select-row input").length;
  var total_checked_boxes = $("td.select-row input:checked").length;
  var master = $("th.select-row input");

  if (total_check_boxes === total_checked_boxes) {
    master.prop("indeterminate", false);
    master.prop("checked", true);
  } else {
    if (total_checked_boxes === 0) {
      master.prop("checked", false);
      master.prop("indeterminate", false);
    } else {
      master.prop("indeterminate", true);
    }
  }

});

// Ignore the above event handler when clicking directly on a link or input element
$(document).on('click', 'tr[data-url] a, tr[data-url] input', function (e) {
  e.stopPropagation()
})
