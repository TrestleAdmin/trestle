import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.addEventListener('turbo:frame-load', this.scrollToTop)
  }

  scrollToTop (e) {
    const table = e.target.querySelector('.table-container').parentElement
    table.scrollIntoView({ behavior: 'smooth' })
  }

  reload () {
    if (this.element.src) {
      this.element.reload()
    } else {
      this.element.src = document.location.href
    }
  }
}
