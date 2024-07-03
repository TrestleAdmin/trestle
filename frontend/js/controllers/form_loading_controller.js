import ApplicationController from './application_controller'

const SUBMIT_BUTTON_SELECTOR = 'input[type="submit"], button[type="submit"]'

export default class extends ApplicationController {
  initialize () {
    this.boundSubmit = this.submit.bind(this)
    this.boundReset = this.reset.bind(this)
  }

  connect () {
    this.element.addEventListener('submit', this.boundSubmit)
    this.element.addEventListener('turbo:before-fetch-response', this.boundReset)
  }

  disconnect () {
    this.element.removeEventListener('submit', this.boundSubmit)
    this.element.removeEventListener('turbo:before-fetch-response', this.boundReset)
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
