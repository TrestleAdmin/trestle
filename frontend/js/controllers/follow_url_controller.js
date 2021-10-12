import { Controller } from '@hotwired/stimulus'
import { visit } from '@hotwired/turbo'

export default class extends Controller {
  follow (e) {
    if (this.ignoreElement(e.target) || !this.url) {
      return
    }

    if (e.metaKey || e.ctrlKey) {
      window.open(this.url, '_blank')
    } else {
      visit(this.url)
    }
  }

  get url () {
    if (this.element.dataset.url === 'auto') {
      return this.element.querySelector('td:not(.table-actions) a').href
    } else {
      return this.element.dataset.url
    }
  }

  ignoreElement (node) {
    return node.matches('a, input, .select-row')
  }
}
