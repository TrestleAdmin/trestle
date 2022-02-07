import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['checkbox', 'selectAll']

  toggle () {
    this.updateSelectAllState()
  }

  toggleAll () {
    const isChecked = this.selectAllTarget.checked

    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = isChecked
    })
  }

  updateSelectAllState () {
    const checked = this.checked
    const checkboxes = this.checkboxTargets

    if (checked.length === checkboxes.length) {
      // All checked
      this.selectAllTarget.indeterminate = false
      this.selectAllTarget.checked = true
    } else if (checked.length == 0) {
      // None checked
      this.selectAllTarget.indeterminate = false
      this.selectAllTarget.checked = false
    } else {
      // Some checked
      this.selectAllTarget.indeterminate = true
    }
  }

  get checked () {
    return this.checkboxTargets.filter((checkbox) => checkbox.checked)
  }

  get unchecked () {
    return this.checkboxTargets.filter((checkbox) => !checkbox.checked)
  }
}
