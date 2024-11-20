import { Controller } from '@hotwired/stimulus'

import { fetchWithErrorHandling, fetchTurboStream } from '../core/fetch'

export default class extends Controller {
  appendAction (event, action, element = this.element) {
    const actions = element.dataset.action ? element.dataset.action.split(' ') : []
    actions.push(`${event}->${this.identifier}#${action}`)
    element.dataset.action = actions.join(' ')
  }

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
