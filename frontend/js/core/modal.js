/* global fetch */

import { renderStreamMessage } from '@hotwired/turbo'
import { Modal as BootstrapModal } from 'bootstrap'

import Backdrop from './backdrop'
import ErrorModal from './error_modal'

export default class Modal extends BootstrapModal {
  static load (url) {
    const backdrop = Backdrop.getInstance()
    backdrop.loading(true)
    backdrop.show()

    Modal.existing.forEach((modal) => modal.classList.add('background'))

    fetch(url, {
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-Trestle-Modal': true
      }
    })
      .then(response => {
        if (!response.ok) { throw response }
        return response.text()
      })
      .then(html => renderStreamMessage(html))
      .catch(response => {
        const title = `${response.status} (${response.statusText})`
        response.text().then(content => ErrorModal.show({ title, content }))
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
