import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.addEventListener('turbo:before-fetch-request', this.addTrestleDialogHeader)
  }

  addTrestleDialogHeader (event) {
    event.detail.fetchOptions.headers['X-Trestle-Dialog'] = true
  }
}
