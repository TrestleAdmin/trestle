import { Controller } from '@hotwired/stimulus'

import { loadModal } from '../core/modal'

export default class extends Controller {
  connect () {
    this.boundLoad = this.load.bind(this)
    this.element.addEventListener('click', this.boundLoad)
  }

  disconnect () {
    this.element.removeEventListener('click', this.boundLoad)
  }

  load (e) {
    e.preventDefault()
    loadModal(this.url)
  }

  get url () {
    return this.element.href
  }
}
