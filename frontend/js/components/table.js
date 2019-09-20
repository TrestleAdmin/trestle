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

// Ignore the above event handler when clicking directly on a link or input element
$(document).on('click', 'tr[data-url] a, tr[data-url] input', function (e) {
  e.stopPropagation()
})
