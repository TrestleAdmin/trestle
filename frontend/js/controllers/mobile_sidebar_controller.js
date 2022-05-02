import ApplicationController from './application_controller'

export default class extends ApplicationController {
  show () {
    this.wrapperController.animate()
    document.body.classList.add('mobile-nav-expanded')
  }

  hide () {
    this.wrapperController.animate()
    document.body.classList.remove('mobile-nav-expanded')
  }

  toggle () {
    this.wrapperController.animate()
    document.body.classList.toggle('mobile-nav-expanded')
  }

  get isExpanded () {
    return document.body.classList.contains('mobile-nav-expanded')
  }

  get wrapperElement () {
    return document.getElementById('app-wrapper')
  }

  get wrapperController () {
    return this.application.getControllerForElementAndIdentifier(this.wrapperElement, 'wrapper')
  }
}
