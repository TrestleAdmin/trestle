import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('turbo:before-fetch-request', this.addTrestleModalHeader)
  }

  addTrestleModalHeader (event) {
    event.detail.fetchOptions.headers['X-Trestle-Modal'] = true
  }
}
