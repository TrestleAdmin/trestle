import { Controller } from '@hotwired/stimulus'

import { fetchWithErrorHandling, fetchTurboStream } from '../core/fetch'

export default class extends Controller {
  fetch (url, options = {}) {
    return fetchWithErrorHandling(url, options)
  }

  fetchTurboStream (url, options = {}) {
    return fetchTurboStream(url, options)
  }

  get csrfToken () {
    return document.querySelector("[name='csrf-token']").content
  }
}
