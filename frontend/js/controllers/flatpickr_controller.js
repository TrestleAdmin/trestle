import ApplicationController from './application_controller'

import flatpickr from 'flatpickr'

export default class extends ApplicationController {
  connect () {
    this.flatpickr = flatpickr(this.element, {
      ...this.options,
      onReady: this.setup.bind(this)
    })
  }

  disconnect () {
    this.flatpickr.destroy()
  }

  clear () {
    const isDisabled = this.element.disabled || this.element.classList.contains('disabled')

    if (!isDisabled) {
      this.flatpickr.clear()
    }
  }

  setup (selectedDates, dateStr, instance) {
    this.#createClearButton(instance)
  }

  get options () {
    return {
      allowInput: true,
      altInput: true
    }
  }

  #createClearButton (instance) {
    if (this.element.dataset.allowClear) {
      const clearButton = document.createElement('button')

      clearButton.classList.add('clear-datepicker')

      clearButton.addEventListener('click', (e) => {
        e.preventDefault()
        this.clear()
      })

      instance.altInput.parentNode.insertBefore(clearButton, instance.altInput)
    }
  }
}
