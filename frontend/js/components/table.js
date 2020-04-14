import $ from 'jquery'

import visit from '../core/visit'

// Allow clicking on any part of a table row to follow either the table's data-url
// or the first link within the row (that is not in the actions column).
$(document).on('click', 'tr[data-url]:not([data-behavior="dialog"])', function (e) {
  const row = $(e.currentTarget)

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
$(document).on('click', 'tr[data-url] a, tr[data-url] input, .select-row', function (e) {
  e.stopPropagation()
})

// Handle clicking on select all checkbox in table header
$(document).on('click', 'th.select-row input', function (e) {
  const table = $(this).closest('table')
  const checked = $(this).is(':checked')

  table.find('td.select-row input').prop('checked', checked)
})

// Handle single row selection to update header row status
$(document).on('click', 'td.select-row input', function (e) {
  const table = $(this).closest('table')

  const checkboxes = table.find('td.select-row input')
  const selectedCheckboxes = checkboxes.filter(':checked')

  const header = table.find('th.select-row input')

  if (checkboxes.length === selectedCheckboxes.length) {
    // All checked
    header.prop('indeterminate', false)
    header.prop('checked', true)
  } else if (selectedCheckboxes.length === 0) {
    // None checked
    header.prop('indeterminate', false)
    header.prop('checked', false)
  } else {
    // Some checked
    header.prop('indeterminate', true)
  }
})
