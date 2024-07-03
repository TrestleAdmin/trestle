import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ["item"]

  static values = {
    class: String
  }

  toggle () {
    this.itemTargets.forEach((item) => {
      item.classList.toggle(this.classValue)
    })
  }

  add () {
    this.itemTargets.forEach((item) => {
      item.classList.add(this.classValue)
    })
  }

  remove () {
    this.itemTargets.forEach((item) => {
      item.classList.remove(this.classValue)
    })
  }
}
