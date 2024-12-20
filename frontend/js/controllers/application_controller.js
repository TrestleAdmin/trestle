import { Controller } from '@hotwired/stimulus'

import { fetchWithErrorHandling, fetchTurboStream } from '../core/fetch'

export default class extends Controller {
  appendAction (event, method, element = this.element) {
    const actions = this.actionsList(element)
    const newAction = `${event}->${this.identifier}#${method}`

    if (!actions.includes(newAction)) {
      actions.push(newAction)
    }

    element.dataset.action = actions.join(' ')
  }

  removeAction (event, method, element = this.element) {
    const newAction = `${event}->${this.identifier}#${method}`
    const actions = this.actionsList(element).filter(action => action !== newAction)

    element.dataset.action = actions.join(' ')
  }

  fetch (url, options = {}) {
    return fetchWithErrorHandling(url, options)
  }

  fetchTurboStream (url, options = {}) {
    return fetchTurboStream(url, options)
  }

  actionsList (element) {
    if (element.dataset.action) {
      return element.dataset.action.split(' ')
    } else {
      return []
    }
  }

  get csrfToken () {
    return document.querySelector("[name='csrf-token']").content
  }
}
