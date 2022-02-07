import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    errorSelector: { type: String, default: '.is-invalid:not([type="hidden"])' }
  }

  connect () {
    this.element.querySelectorAll('.nav-link').forEach((link) => {
      this.updateErrorCount(link)
    })
  }

  updateErrorCount (link) {
    const pane = document.querySelector(link.getAttribute('href'))
    const errorCount = pane.querySelectorAll(this.errorSelectorValue).length

    if (errorCount > 0) {
      const badge = this._createErrorBadge(errorCount)
      link.appendChild(badge)
    }
  }

  _createErrorBadge (count) {
    const badge = document.createElement('span')

    badge.classList.add('badge', 'badge-danger', 'badge-pill')
    badge.textContent = count

    return badge
  }
}
