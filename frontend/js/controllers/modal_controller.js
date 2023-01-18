import ApplicationController from './application_controller'

import Modal from '../core/modal'

export default class extends ApplicationController {
  static outlets = ['modal-trigger']

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
    if (this.hasModalTriggerOutlet) {
      const event = this.modalTriggerOutlet.dispatch('submit', { detail: detail })

      if (!event.defaultPrevented) {
        this.hide()
      }
    } else {
      this.hide()
    }
  }
}
