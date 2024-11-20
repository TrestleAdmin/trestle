import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static values = {
    url: String
  }

  connect () {
    this.appendAction('turbo:frame-load', 'scrollToTop')
  }

  scrollToTop (e) {
    const scrollTarget = this.element.closest('[data-scroll-target]')
    const boundingRect = scrollTarget.getBoundingClientRect()

    if (scrollTarget && boundingRect.top < 0) {
      scrollTarget.scrollIntoView()
    }
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
