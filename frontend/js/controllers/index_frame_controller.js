import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('turbo:frame-load', this.scrollToTop)
  }

  scrollToTop (e) {
    const table = e.target.querySelector('.table-container').parentElement
    table.scrollIntoView()
  }

  reload () {
    if (this.element.src) {
      this.element.reload()
    } else {
      this.element.src = document.location.href
    }
  }
}
