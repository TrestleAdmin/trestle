import { Controller } from '@hotwired/stimulus'

import { fetchWithErrorHandling, fetchTurboStream } from '../core/fetch'

export default class extends Controller {
  appendAction (event, method, element = this.element) {
    const actions = this.actionsList
    actions.push(`${event}->${this.identifier}#${method}`)

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

  get actionsList () {
    if (element.dataset.action) {
      return element.dataset.action.split(' ')
    } else {
      return []
    }
  }
}
