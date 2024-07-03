import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static outlets = ['mobile-sidebar']

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
    const sidebarController = this.mobileSidebarOutlet

    if (!sidebarController.isExpanded) {
      return
    }

    const clickInHeader = e.target.closest('.app-header')
    const clickInSidebar = e.target.closest('.app-sidebar')

    if (!clickInHeader && !clickInSidebar) {
      e.stopPropagation()
      e.preventDefault()

      sidebarController.hide()
    }
  }
}
