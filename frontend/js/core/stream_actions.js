/* global CustomEvent */

import { StreamActions } from '@hotwired/turbo'

const buildModalEvent = (modal) => {
  return new CustomEvent('modal:render', { detail: modal })
}

StreamActions.modal = function () {
  const target = document.getElementById('modal')
  const modal = this.templateContent.querySelector('*')

  target.appendChild(modal)
  target.dispatchEvent(buildModalEvent(modal))
}
