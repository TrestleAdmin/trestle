import ApplicationController from './application_controller'

import Modal from '../core/modal'

export default class extends ApplicationController {
  connect () {
    this.modal = new Modal(this.element)
    this.modal.show()

    this.element.addEventListener('hidden.bs.modal', () => this.remove())
  }

  disconnect () {
    this.modal.dispose()
  }

  remove () {
    this.element.remove()
  }

  hide () {
    this.modal.hide()
  }

  submit (detail) {
    let event = this.dispatch('submit', { detail: detail })
    if (event.defaultPrevented) return

    if (this.modalTrigger) {
      event = this.modalTrigger.dispatch('submit', { detail: detail })
      if (event.defaultPrevented) return
    }

    this.hide()
  }
}
