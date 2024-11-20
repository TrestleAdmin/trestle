import ApplicationController from './application_controller'

const SUBMIT_BUTTON_SELECTOR = 'input[type="submit"], button[type="submit"]'

export default class extends ApplicationController {
  connect () {
    this.appendAction('submit', 'submit')
    this.appendAction('turbo:before-fetch-response', 'reset')
  }

  submit (e) {
    this.disableButtons()
    this.setLoading(e.submitter || this.element.querySelector(SUBMIT_BUTTON_SELECTOR))
  }

  reset (e) {
    this.restoreButtons()
  }

  setLoading (button) {
    button.classList.add('loading')
  }

  disableButtons (e) {
    this.submitButtons.forEach(button => {
      button.disabled = true
    })
  }

  restoreButtons () {
    this.submitButtons.forEach(button => {
      button.classList.remove('loading')
      button.disabled = false
    })
  }

  get submitButtons () {
    return this.element.querySelectorAll(SUBMIT_BUTTON_SELECTOR)
  }
}
