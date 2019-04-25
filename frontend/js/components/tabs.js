import $ from 'jquery'

import { init, ready } from '../core/events'

// Save active tab to URL hash
init(function (root) {
  $(root).find("a[data-toggle='tab']").on('shown.bs.tab', function (e) {
    const hash = $(this).attr('href')
    const withinModal = $(this).closest('.modal').length > 0

    if (hash.substr(0, 1) === '#' && !withinModal) {
      history.replaceState({ turbolinks: {} }, '', '#!' + hash.substr(1))
    }
  })
})

// Restore active tab when loading
ready(function () {
  focusActiveTab()
})

// Add error count to tabs
init(function (root) {
  $(root).find('.tab-pane').each(function () {
    const errorCount = $(this).find('.is-invalid').length

    if (errorCount > 0) {
      const badge = $('<span>').addClass('badge badge-danger badge-pill').text(errorCount)
      const selector = `.nav-tabs a[href="#${$(this).attr('id')}"]`
      $(selector).append(badge)
    }
  })
})

export function focusTab (id) {
  const selector = `a[data-toggle='tab'][href='#${id}']`
  $(selector).tab('show')
}

export function focusActiveTab () {
  if (location.hash.substr(0, 2) === '#!') {
    // Focus on active tab from URL
    focusTab(location.hash.substr(2))
  } else {
    const $errorTabs = $('.tab-pane:has(.has-error)')

    if ($errorTabs.length) {
      focusTab($errorTabs.first().attr('id'))
    }
  }
}
