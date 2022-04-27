import { Controller } from '@hotwired/stimulus'

import Modal from '../core/modal'

export default class extends Controller {
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
}
