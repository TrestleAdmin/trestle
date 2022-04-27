import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  initialize () {
    this.boundHandleKeyDown = this.handleKeyDown.bind(this)
  }

  connect () {
    this.element.addEventListener('keydown', this.boundHandleKeyDown)
  }

  disconnect () {
    this.element.removeEventListener('keydown', this.boundHandleKeyDown)
  }

  handleKeyDown (e) {
    if (e.key === 'Enter' && this.preventEnterKey(e.target)) {
      e.preventDefault()
    }
  }

  preventEnterKey (el) {
    return el.matches('input:not([type="submit"])')
  }
}
