import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ["item"]

  static values = {
    attribute: String
  }

  toggle () {
    this.itemTargets.forEach((item) => {
      item[this.attributeValue] = !item[this.attributeValue]
    })
  }

  set () {
    this.itemTargets.forEach((item) => {
      item[this.attributeValue] = true
    })
  }

  unset () {
    this.itemTargets.forEach((item) => {
      item[this.attributeValue] = false
    })
  }
}
