import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.appendAction('turbo:before-fetch-request', 'addTrestleModalHeader')
  }

  addTrestleModalHeader (event) {
    event.detail.fetchOptions.headers['X-Trestle-Modal'] = true
  }
}
