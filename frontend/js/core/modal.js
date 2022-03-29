/* global fetch */

import { renderStreamMessage } from '@hotwired/turbo'

export function loadModal (url) {
  fetch(url, {
    headers: {
      Accept: 'text/vnd.turbo-stream.html',
      'X-Trestle-Dialog': true
    }
  })
    .then(response => response.text())
    .then(html => renderStreamMessage(html))
}
