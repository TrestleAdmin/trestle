import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.boundReloadIndexFrames = this.reloadIndexFrames.bind(this)
    this.element.addEventListener('turbo:submit-end', this.boundReloadIndexFrames)
  }

  reloadIndexFrames () {
    this.indexFrames.forEach((frame) => {
      this.controllerForFrame(frame).reload()
    })
  }

  controllerForFrame (frame) {
    return this.application.getControllerForElementAndIdentifier(frame, 'index-frame')
  }

  get indexFrames () {
    return document.querySelectorAll('[data-controller="index-frame"]')
  }
}
