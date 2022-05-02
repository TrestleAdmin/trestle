import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('turbo:before-fetch-request', this.addTrestleDialogHeader)
  }

  addTrestleDialogHeader (event) {
    event.detail.fetchOptions.headers['X-Trestle-Dialog'] = true
  }
}
