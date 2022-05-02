import ApplicationController from './application_controller'

import Modal from '../core/modal'

export default class extends ApplicationController {
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
