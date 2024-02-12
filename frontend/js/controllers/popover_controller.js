import ApplicationController from './application_controller'

import { Popover } from 'bootstrap'

export default class extends ApplicationController {
  static values = {
    title: { type: String, default: '' },
    content: { type: String, default: '' },
    placement: { type: String, default: 'left' },
    html: { type: Boolean, default: false },
    trigger: { type: String, default: 'click' }
  }

  static classes = [ "custom" ]

  initialize () {
    this.boundHide = this.hide.bind(this)

    this.boundOnShown = this.onShown.bind(this)
    this.boundOnHidden = this.onHidden.bind(this)
  }

  connect () {
    this.popover = new Popover(this.element, this.popoverOptions)

    this.element.addEventListener('shown.bs.popover', this.boundOnShown)
    this.element.addEventListener('hidden.bs.popover', this.boundOnHidden)
  }

  disconnect () {
    this.element.removeEventListener('shown.bs.popover', this.boundOnShown)
    this.element.removeEventListener('hidden.bs.popover', this.boundOnHidden)

    document.removeEventListener('click', this.boundHide)

    if (this.popover._isEnabled) {
      this.popover.dispose()
    }
  }

  show () {
    this.popover.show()
  }

  toggle () {
    this.popover.toggle()
  }

  hide (e) {
    if (e && this.popover.tip && this.popover.tip.contains(e.target)) {
      return
    }

    this.popover.hide()
  }

  onShown () {
    document.addEventListener('click', this.boundHide)
  }

  onHidden () {
    document.removeEventListener('click', this.boundHide)
  }

  get popoverOptions () {
    return {
      title: this.titleValue,
      content: this.content,
      placement: this.placementValue,
      trigger: this.triggerValue,
      html: this.htmlValue,
      customClass: this.hasCustomClass ? this.customClass : ''
    }
  }

  get content () {
    return this.contentValue
  }
}
