import { Controller } from '@hotwired/stimulus'

const EVENTS = ['transitionend', 'webkitTransitionEnd']

export default class extends Controller {
  static targets = ['sidebar']

  connect () {
    this.boundStopAnimating = this.stopAnimating.bind(this)
    EVENTS.forEach((event) => this.element.addEventListener(event, this.boundStopAnimating))
  }

  disconnect () {
    EVENTS.forEach((event) => this.element.removeEventListener(event, this.boundStopAnimating))
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
