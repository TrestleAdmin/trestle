import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.appendAction('keydown', 'handleKeyDown')
  }

  handleKeyDown (e) {
    if (e.key === 'Enter' && this.preventEnterKey(e.target)) {
      e.preventDefault()
    }
  }

  preventEnterKey (el) {
    return el.matches('input:not([type="submit"])')
  }
}
