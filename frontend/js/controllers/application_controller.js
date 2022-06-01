import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  get csrfToken () {
    return document.querySelector("[name='csrf-token']").content
  }
}
