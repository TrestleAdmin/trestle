/* global FormData */

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

    this.modalIdentifier = Date.now()

    this.dispatch('loading')

    Modal.load(this.url, this.modalIdentifier, this.fetchParams)
      .then(() => {
        this.dispatch('loaded')
      })
      .catch(() => {
        this.modalIdentifier = null
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

  get modalIdentifier () {
    return this._modalIdentifier
  }

  set modalIdentifier (id) {
    this._modalIdentifier = id
    this.element.setAttribute('data-modal-id', id)
  }

  get isLink () {
    return this.element.nodeName === 'A'
  }
}
