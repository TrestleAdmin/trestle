import Modal from './modal'

import { reflow, execute, executeAfterTransition } from '../util/bootstrap'

const Default = {
  className: 'modal-backdrop',
  isAnimated: true
}

const CLASS_NAME_FADE = 'fade'
const CLASS_NAME_SHOW = 'show'
const CLASS_NAME_LOADING = 'loading'

export default class Backdrop {
  static getInstance () {
    if (!this.instance) {
      this.instance = new Backdrop()
    }

    return this.instance
  }

  constructor () {
    this._config = Default
    this._element = null
    this._isAppended = false
  }

  show (callback) {
    this._append()

    if (this._config.isAnimated) {
      reflow(this._getElement())
    }

    this._getElement().classList.add(CLASS_NAME_SHOW)

    this._emulateAnimation(() => {
      execute(callback)
    })
  }

  hide (callback) {
    if (Modal.existing.length === 0) {
      this._getElement().classList.remove(CLASS_NAME_SHOW)
    }

    this._emulateAnimation(() => {
      this.dispose()
      execute(callback)
      Modal.restorePrevious()
    })
  }

  dispose () {
    if (!this._isAppended) {
      return
    }

    if (Modal.existing.length === 0) {
      this._element.remove()
      this._isAppended = false
    }
  }

  loading (isLoading) {
    const el = this._getElement()
    el.classList[isLoading ? 'add' : 'remove'](CLASS_NAME_LOADING)
  }

  // Private

  _getElement () {
    if (!this._element) {
      const backdrop = document.createElement('div')
      backdrop.className = this._config.className
      if (this._config.isAnimated) {
        backdrop.classList.add(CLASS_NAME_FADE)
      }

      this._element = backdrop
    }

    return this._element
  }

  _append () {
    if (this._isAppended) {
      return
    }

    document.body.append(this._getElement())

    this._isAppended = true
  }

  _emulateAnimation (callback) {
    executeAfterTransition(callback, this._getElement(), this._config.isAnimated)
  }
}
