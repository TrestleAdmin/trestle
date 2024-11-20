/* global FormData */

import ApplicationController from './application_controller'

import Modal from '../core/modal'

export default class extends ApplicationController {
  connect () {
    this.appendAction('click', 'load')
  }

  load (e) {
    e.preventDefault()

    this.dispatch('loading')

    Modal.load(this.url, this.fetchParams)
      .then((modal) => {
        this.modal = modal

        const modalController = this.#getModalController(modal)
        modalController.modalTrigger = this

        this.dispatch('loaded', { detail: modal })
      })
  }

  get url () {
    if (this.isLink) {
      return this.element.href
    } else {
      const form = this.element.closest('form')

      if (form) {
        return form.action
      } else {
        throw new Error('Unable to determine modal trigger URL')
      }
    }
  }

  get fetchParams () {
    if (this.isLink) {
      return {}
    } else {
      const form = this.element.closest('form')

      if (form) {
        return {
          method: form.method,
          body: new FormData(form)
        }
      } else {
        return {}
      }
    }
  }

  get isLink () {
    return this.element.nodeName === 'A'
  }

  #getModalController (modal) {
    return this.application.getControllerForElementAndIdentifier(modal, 'modal')
  }
}
