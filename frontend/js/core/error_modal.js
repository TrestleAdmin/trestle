/* global DOMParser */

import { i18n } from '../core/i18n'

const TEMPLATE = () => `
<div class="modal fade error-modal" tabindex="-1" data-controller="modal">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title"></h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal" aria-label="OK">${i18n.t('admin.buttons.ok', { defaultValue: 'OK' })}</button>
      </div
    </div>
  </div>
</div>
`

export default class ErrorModal {
  static show ({ title, content }) {
    new ErrorModal({ title, content }).show()
  }

  constructor ({ title, content }) {
    this.title = title
    this.content = content
  }

  show () {
    this._append(this._buildModal())
  }

  // Private

  _buildModal () {
    const el = this._buildWrapper()
    el.querySelector('.modal-title').textContent = this.title

    const iframe = this._buildIframe(this.content)
    el.querySelector('.modal-body').append(iframe)

    return el
  }

  _buildWrapper () {
    return new DOMParser().parseFromString(TEMPLATE(), 'text/html').body.childNodes[0]
  }

  _buildIframe () {
    const iframe = document.createElement('iframe')
    iframe.className = 'error-iframe'
    iframe.srcdoc = this.content
    return iframe
  }

  _append (el) {
    document.getElementById('modal').append(el)
  }
}
