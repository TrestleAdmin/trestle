import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static values = {
    url: String
  }

  initialize () {
    this.boundScrollToTop = this.scrollToTop.bind(this)
  }

  connect () {
    this.element.addEventListener('turbo:frame-load', this.boundScrollToTop)
  }

  scrollToTop (e) {
    const scrollTarget = this.element.closest('[data-scroll-target]')
    if (scrollTarget) { scrollTarget.scrollIntoView() }
  }

  reload () {
    if (this.element.src) {
      this.element.reload()
    } else if (this.hasUrlValue) {
      this.element.src = this.urlValue
    } else {
      this.element.src = document.location.href
    }
  }
}
