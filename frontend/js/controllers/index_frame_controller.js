import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ["scroll"]

  initialize () {
    this.boundScrollToTop = this.scrollToTop.bind(this)
  }

  connect () {
    this.element.addEventListener('turbo:frame-load', this.boundScrollToTop)
  }

  scrollToTop (e) {
    if (this.hasScrollTarget) {
      this.scrollTarget.scrollIntoView()
    }
  }

  reload () {
    if (this.element.src) {
      this.element.reload()
    } else {
      this.element.src = document.location.href
    }
  }
}
