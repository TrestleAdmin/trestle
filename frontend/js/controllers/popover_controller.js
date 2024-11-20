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
  }

  connect () {
    this.popover = new Popover(this.element, this.popoverOptions)

    this.appendAction('shown.bs.popover', 'onShown')
    this.appendAction('hidden.bs.popover', 'onHidden')
  }

  disconnect () {
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

  clickWithinPopover (e) {
    return this.popover.tip && this.popover.tip.contains(e.target)
  }

  hide (e) {
    if (e && this.clickWithinPopover(e)) {
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
      title: this.title,
      content: this.content,
      placement: this.placementValue,
      trigger: this.triggerValue,
      html: this.htmlValue,
      customClass: this.hasCustomClass ? this.customClass : ''
    }
  }

  get title () {
    return this.titleValue
  }

  get content () {
    return this.contentValue
  }
}
