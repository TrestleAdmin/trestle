import PopoverController from './popover_controller'

import { i18n } from '../core/i18n'

export default class extends PopoverController {
  static values = {
    confirmLabel: String,
    cancelLabel: String
  }

  static classes = [ 'confirm', 'cancel' ]

  static defaultConfirmClass = 'btn-primary'
  static defaultCancelClass = 'btn-light'

  initialize () {
    super.initialize()

    this.boundOnClick = this.onClick.bind(this)

    this.confirmed = false
  }

  connect () {
    super.connect()

    this.element.addEventListener('click', this.boundOnClick, { capture: true })
  }

  disconnect () {
    super.disconnect()

    this.element.removeEventListener('click', this.boundOnClick, { capture: true })
  }

  onClick (e) {
    if (!this.confirmed) {
      e.preventDefault()
      e.stopImmediatePropagation()

      this.toggle()
    }
  }

  confirm () {
    this.popover.dispose()

    this.confirmed = true
    this.element.click()
    this.confirmed = false
  }

  cancel () {
    this.popover.hide()
  }

  get popoverOptions () {
    return {
      ...super.popoverOptions,
      html: true
    }
  }

  get content () {
    const group = document.createElement('div')
    group.classList.add('btn-group')

    group.appendChild(this.confirmButton)
    group.appendChild(this.cancelButton)

    return group
  }

  get confirmButton () {
    const button = document.createElement('button')

    button.classList.add('btn', 'btn-sm', this.confirmButtonClass)
    button.textContent = this.confirmLabel

    button.addEventListener('click', this.confirm.bind(this))

    return button
  }

  get cancelButton () {
    const button = document.createElement('button')

    button.classList.add('btn', 'btn-sm', this.cancelButtonClass)
    button.textContent = this.cancelLabel

    button.addEventListener('click', this.cancel.bind(this))

    return button
  }

  get title () {
    return this.titleValue || i18n['trestle.confirmation.title'] || 'Are you sure?'
  }

  get confirmLabel () {
    return this.confirmLabelValue || i18n['trestle.confirmation.ok'] || 'OK'
  }

  get cancelLabel () {
    return this.cancelLabelValue || i18n['trestle.confirmation.cancel'] || 'Cancel'
  }

  get confirmButtonClass () {
    return this.hasConfirmClass ? this.confirmClass : this.constructor.defaultConfirmClass
  }

  get cancelButtonClass () {
    return this.hasCancelClass ? this.cancelClass : this.constructor.defaultCancelClass
  }
}
