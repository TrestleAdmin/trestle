import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['sidebar']

  initialize () {
    this.boundStopAnimating = this.stopAnimating.bind(this)
  }

  connect () {
    this.element.addEventListener('transitionend', this.boundStopAnimating)
  }

  disconnect () {
    this.element.removeEventListener('transitionend', this.boundStopAnimating)
  }

  animate () {
    this.element.classList.add('animate')
  }

  stopAnimating () {
    this.element.classList.remove('animate')
  }

  hideMobileSidebar (e) {
    const mobileSidebar = this.mobileSidebarController

    if (!mobileSidebar.isExpanded) {
      return
    }

    const clickInHeader = e.target.closest('.app-header')
    const clickInSidebar = e.target.closest('.app-sidebar')

    if (!clickInHeader && !clickInSidebar) {
      e.stopPropagation()
      e.preventDefault()

      mobileSidebar.hide()
    }
  }

  get mobileSidebarController () {
    return this.application.getControllerForElementAndIdentifier(this.sidebarTarget, 'mobile-sidebar')
  }
}
