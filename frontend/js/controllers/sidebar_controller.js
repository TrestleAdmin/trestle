import ApplicationController from './application_controller'

import cookie from '../core/cookie'

export default class extends ApplicationController {
  static targets = ["inner"]

  static values = {
    scrollMargin: { type: Number, default: 100 }
  }

  connect () {
    this.scrollToActive()
  }

  toggle () {
    const bodyClasses = document.body.classList

    if (bodyClasses.contains('sidebar-expanded') || bodyClasses.contains('sidebar-collapsed')) {
      bodyClasses.remove('sidebar-expanded', 'sidebar-collapsed')
      cookie.delete('trestle:sidebar')
    } else if (document.body.clientWidth >= 1200) {
      bodyClasses.add('sidebar-collapsed')
      cookie.set('trestle:sidebar', 'collapsed')
    } else if (document.body.clientWidth >= 768) {
      bodyClasses.add('sidebar-expanded')
      cookie.set('trestle:sidebar', 'expanded')
    }
  }

  scrollToActive () {
    if (!this.hasInnerTarget) return

    const active = this.element.querySelector('.active')
    if (!active) return

    // Check if bottom of active element is outside of visible navigation height (plus scroll margin)
    const activeOffset = active.offsetTop + active.offsetHeight + this.scrollMarginValue
    if (activeOffset > this.innerTarget.clientHeight) {
      this.innerTarget.scrollTop = activeOffset - this.innerTarget.clientHeight
    }
  }
}
