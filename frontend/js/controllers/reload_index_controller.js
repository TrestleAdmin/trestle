import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  initialize () {
    this.boundReloadIndexFrames = this.reloadIndexFrames.bind(this)
  }

  connect () {
    this.element.addEventListener('turbo:submit-end', this.boundReloadIndexFrames)
  }

  reloadIndexFrames (e) {
    const response = e.detail.fetchResponse.response

    if (response.ok) {
      this.indexFrames.forEach((frame) => {
        this.controllerForFrame(frame).reload()
      })
    }
  }

  controllerForFrame (frame) {
    return this.application.getControllerForElementAndIdentifier(frame, 'index-frame')
  }

  get indexFrames () {
    return document.querySelectorAll('[data-controller="index-frame"]')
  }
}
