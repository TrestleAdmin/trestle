/* global history */

import $ from 'jquery'

import { init, triggerInit } from '../core/events'
import { refreshMainContext } from '../core/contexts'

import { focusActiveTab } from './tabs'
import { showError } from './dialog'

const FORM_SELECTOR = 'form[data-behavior="trestle-form"]'

// Prevent enter key from submitting the form
$(document).on('keypress', `${FORM_SELECTOR} :input:not(textarea):not([type=submit])`, function (e) {
  if (e.keyCode === 13) {
    e.preventDefault()
  }
})

init(function (root) {
  const $form = $(root).find(FORM_SELECTOR)

  $form
    .on('ajax:send', function (e) {
      // Only run when triggered directly on form
      if (e.target !== this) return

      // Disable submit buttons
      $(this).find(':submit').prop('disabled', true)

      // Set loading status on button that triggered submission
      const button = $(this).data('trestle:submitButton')
      if (button) { $(button).addClass('loading') }
    })
    .on('ajax:complete', function (e) {
      // Only run when triggered directly on form
      if (e.target !== this) return

      const xhr = e.detail[0]

      // Reset submit buttons
      $(this).find(':submit').prop('disabled', false).removeClass('loading')
      $(this).removeData('trestle:submitButton')

      const contentType = (xhr.getResponseHeader('Content-Type') || '').split(';')[0]

      if (contentType === 'text/html') {
        if (/<html/i.test(xhr.responseText)) {
          // Response is a full HTML page, likely an error page. Render within an iframe.
          const $context = $(this).closest('[data-context]')
          const iframe = $('<iframe>').addClass('error-iframe').get(0)
          $context.html(iframe)

          iframe.contentWindow.document.documentElement.innerHTML = xhr.responseText
        } else {
          // Find the parent context and replace content
          const $context = $(this).closest('[data-context]')
          $context.html(xhr.responseText)

          // Initialize replaced elements within the context
          triggerInit($context)

          // Focus the correct tab
          focusActiveTab()
        }
      } else if (contentType === 'text/plain') {
        // Assume an error response
        const title = `${xhr.status} (${xhr.statusText})`
        showError(title, xhr.responseText)
      }
    })
    .on('ajax:success', function (e) {
      // Only run when triggered directly on form
      if (e.target !== this) return

      const xhr = e.detail[2]

      const $context = $(this).closest('[data-context]')
      let location = xhr.getResponseHeader('X-Trestle-Location')

      if (location) {
        // Retain current active tab
        location = location + document.location.hash

        // Update the URL in the browser and context
        history.replaceState({}, '', location)
        $context.data('context', location)
      }

      // Refresh the main context
      if (!$context.hasClass('app-main')) {
        refreshMainContext()
      }
    })

  $form.find(':submit').click(function () {
    // Save this as the button that triggered the form
    $(this).closest('form').data('trestle:submitButton', this)
  })
})
