import { Modal as BootstrapModal } from 'bootstrap'

import Backdrop from './backdrop'
import { fetchTurboStream } from './fetch'

export default class Modal extends BootstrapModal {
  static load (url, modalId, fetchParams) {
    const backdrop = Backdrop.getInstance()
    backdrop.loading(true)
    backdrop.show()

    Modal.existing.forEach((modal) => modal.classList.add('background'))

    return fetchTurboStream(url, {
      ...fetchParams,

      headers: {
        'X-Trestle-Modal': true,
        'X-Trestle-Modal-ID': modalId
      }
    })
  }

  static get existing () {
    return document.querySelectorAll('.modal.show')
  }

  static restorePrevious () {
    const previousModal = document.querySelector('.modal.show:last-child')

    if (previousModal) {
      previousModal.classList.remove('background')
    }
  }

  constructor (element) {
    super(element)

    element.addEventListener('show.bs.modal', () => {
      this._backdrop.loading(false)
    })
  }

  _initializeBackDrop () {
    return Backdrop.getInstance()
  }
}
