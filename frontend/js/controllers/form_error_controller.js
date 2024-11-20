import ApplicationController from './application_controller'

import ErrorModal from '../core/error_modal'

export default class extends ApplicationController {
  connect () {
    this.appendAction('turbo:before-fetch-response', 'handleFormResponse')
  }

  handleFormResponse (e) {
    const response = e.detail.fetchResponse.response

    if (response.status >= 500) {
      e.preventDefault()

      const title = `${response.status} (${response.statusText})`
      response.text().then(content => ErrorModal.show({ title, content }))
    }
  }
}
