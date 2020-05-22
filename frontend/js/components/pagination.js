/* global history */

import $ from 'jquery'

import { triggerInit } from '../core/events'

const REMOTE_PAGINATION_SELECTOR = '.page-link[data-remote]'

$(document)
  .on('ajax:send', function (e) {
    const $context = $(e.target).closest('[data-context]')
    const $table = $context.find('.table-container')
    $table.addClass('loading')
  })

  .on('ajax:complete', function (e) {
    const $context = $(e.target).closest('[data-context]')
    const $table = $context.find('.table-container')
    $table.removeClass('loading')
  })

  .on('ajax:success', REMOTE_PAGINATION_SELECTOR, function (e) {
    const $link = $(e.target)
    const $context = $link.closest('[data-context]')

    // Update table and pagination
    const $doc = $(e.detail[0])

    const $table = $doc.find('.table-container')
    $context.find('.table-container').replaceWith($table)

    triggerInit($table)

    const $pagination = $doc.find('.pagination-container')
    $context.find('.pagination-container').replaceWith($pagination)

    // Update the URL in the browser and context
    const location = $link.attr('href')

    if (location) {
      // TODO: Implement URL updating with back button support
      // if ($context.hasClass('app-main')) {
      //   history.pushState({}, '', location)
      // }

      $context.data('context', location)
    }

    // Scroll to top of table
    $table[0].scrollIntoView(true)
  })
