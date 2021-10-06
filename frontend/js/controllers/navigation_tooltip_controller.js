import { Controller } from '@hotwired/stimulus'

import { Tooltip } from 'bootstrap'

const TEMPLATE = `
<div class="tooltip nav-tooltip" role="tooltip">
  <div class="tooltip-arrow"></div>
  <div class="tooltip-inner"></div>
</div>
`

export default class extends Controller {
  static targets = ["label"]

  connect () {
    this.tooltip = new Tooltip(this.element, {
      trigger: 'hover',
      placement: 'right',
      boundary: 'window',
      template: TEMPLATE,
      title: () => this.labelText
    })
  }

  disconnect () {
    this.tooltip.dispose()
  }

  get labelText () {
    return this.labelTarget.innerText
  }
}
