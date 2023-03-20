/* global fetch */

import { renderStreamMessage } from '@hotwired/turbo'

import ErrorModal from './error_modal'

export function fetchWithErrorHandling (url, options = {}) {
  return fetch(url, options)
    .then(response => {
      if (!response.ok) { throw response }
      return response
    })
    .catch(response => {
      const title = `${response.status} (${response.statusText})`
      response.text().then(content => ErrorModal.show({ title, content }))
    })
}

export function fetchTurboStream (url, options = {}) {
  options = {
    ...options,

    headers: {
      Accept: 'text/vnd.turbo-stream.html',
      ...options.headers
    }
  }

  return fetchWithErrorHandling(url, options)
    .then(response => response.text())
    .then(html => renderStreamMessage(html))
}
