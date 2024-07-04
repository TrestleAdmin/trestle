import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static outlets = ['checkbox-select']

  connect () {
    if (!this.hasCheckboxSelectOutlet) {
      // Set default outlet if none specified
      this.element.setAttribute(`data-${this.identifier}-checkbox-select-outlet`, '.trestle-table')
    }

    this.baseHref = this.element.href

    this.update()
  }

  update () {
    this.toggleEnabled()
    this.updateHref()
  }

  toggleEnabled () {
    this.element.classList.toggle('disabled', this.checkboxes.length === 0)
  }

  updateHref () {
    this.element.href = this.hrefWithSelectedIds
  }

  get checkboxes () {
    if (this.hasCheckboxSelectOutlet) {
      return this.checkboxSelectOutlet.checked
    } else {
      return []
    }
  }

  get selectedIds () {
    return this.checkboxes.map(c => c.value)
  }

  get hrefWithSelectedIds () {
    const ids = this.selectedIds

    if (ids.length) {
      return `${this.baseHref}?ids=${ids.join(',')}`
    } else {
      return this.baseHref
    }
  }

  checkboxSelectOutletConnected (outlet, element) {
    element.addEventListener('checkbox-select:change', this.update.bind(this))
  }

  checkboxSelectOutletDisconnected (outlet, element) {
    element.removeEventListener('checkbox-select:change', this.update.bind(this))
  }
}
