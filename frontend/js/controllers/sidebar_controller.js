import ApplicationController from './application_controller'

import cookie from '../core/cookie'

export default class extends ApplicationController {
  static targets = ["inner"]

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
    const active = this.element.getElementsByClassName('active')[0]
    if (active && this.hasInnerTarget) {
      this.innerTarget.scrollTop = active.offsetTop - 100
    }
  }
}
