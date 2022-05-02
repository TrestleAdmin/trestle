import ApplicationController from './application_controller'

import { visit } from '@hotwired/turbo'
import Modal from '../core/modal'

export default class extends ApplicationController {
  follow (e) {
    if (this.ignoreElement(e.target) || !this.url) {
      return
    }

    if (this.isModal) {
      Modal.load(this.url)
    } else if (e.metaKey || e.ctrlKey) {
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

  get isModal () {
    return this.element.dataset.modal
  }

  ignoreElement (node) {
    return node.matches('a, input, button, .select-row')
  }
}
