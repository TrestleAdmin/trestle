/* global CustomEvent */

import { StreamActions } from '@hotwired/turbo'

import { Modal } from 'bootstrap'

const buildModalEvent = (modal) => {
  return new CustomEvent('modal:render', { detail: modal })
}

StreamActions.modal = function () {
  const target = document.getElementById('modal')
  const modal = this.templateContent.querySelector('*')

  target.appendChild(modal)
  target.dispatchEvent(buildModalEvent(modal))
}

StreamActions.closeModal = function () {
  this.targetElements.forEach((e) => {
    const modalEl = e.closest('.modal')
    const modal = Modal.getInstance(modalEl)
    if (modal) { modal.hide() }
  })
}

StreamActions.flash = function () {
  const flashTarget = document.querySelector('.modal.show .modal-flash') || document.querySelector('#flash')

  flashTarget.innerHTML = ""
  flashTarget.append(this.templateContent)
}

StreamActions.reload = function () {
  let reloadables

  if (this.target || this.targets) {
    reloadables = this.targetElements
  } else {
    reloadables = document.querySelectorAll('[data-controller="reloadable"]')
  }

  reloadables.forEach((frame) => {
    const modal = frame.closest('.modal')
    if (modal && !modal.classList.contains('show')) {
      return
    }

    const controller = Stimulus.getControllerForElementAndIdentifier(frame, 'reloadable')
    if (controller) { controller.reload() }
  })
}
