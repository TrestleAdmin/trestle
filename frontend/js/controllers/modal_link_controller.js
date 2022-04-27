import { Controller } from '@hotwired/stimulus'

import Modal from '../core/modal'

export default class extends Controller {
  initialize () {
    this.boundLoad = this.load.bind(this)
  }

  connect () {
    this.element.addEventListener('click', this.boundLoad)
  }

  disconnect () {
    this.element.removeEventListener('click', this.boundLoad)
  }

  load (e) {
    e.preventDefault()
    Modal.load(this.url)
  }

  get url () {
    return this.element.href
  }
}
