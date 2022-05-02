import ApplicationController from './application_controller'

import { Tab } from 'bootstrap'

export default class extends ApplicationController {
  static values = {
    errorSelector: { type: String, default: '.is-invalid:not([type="hidden"])' }
  }

  connect () {
    this.element.querySelectorAll('.nav-link').forEach((link) => {
      this.updateErrorCount(link)
    })

    this.focusFirstTabWithErrors()
  }

  updateErrorCount (link) {
    const pane = document.querySelector(link.getAttribute('href'))
    const errorCount = pane.querySelectorAll(this.errorSelectorValue).length

    if (errorCount > 0) {
      const badge = this._createErrorBadge(errorCount)
      link.appendChild(badge)
    }
  }

  focusFirstTabWithErrors () {
    this.element.querySelectorAll('.nav-link').forEach((link) => {
      if (link.querySelector('.badge-danger')) {
        Tab.getOrCreateInstance(link).show()
        return
      }
    })
  }

  _createErrorBadge (count) {
    const badge = document.createElement('span')

    badge.classList.add('badge', 'badge-danger', 'badge-pill')
    badge.textContent = count

    return badge
  }
}
