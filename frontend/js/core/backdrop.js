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
  #config
  #element
  #isAppended

  static getInstance () {
    if (!this.instance) {
      this.instance = new Backdrop()
    }

    return this.instance
  }

  constructor () {
    this.#config = Default
    this.#element = null
    this.#isAppended = false
  }

  show (callback) {
    this.#append()

    if (this.#config.isAnimated) {
      reflow(this.#getElement())
    }

    this.#getElement().classList.add(CLASS_NAME_SHOW)

    this.#emulateAnimation(() => {
      execute(callback)
    })
  }

  hide (callback) {
    if (Modal.existing.length === 0) {
      this.#getElement().classList.remove(CLASS_NAME_SHOW)
    }

    this.#emulateAnimation(() => {
      this.dispose()
      execute(callback)
      Modal.restorePrevious()
    })
  }

  dispose () {
    if (!this.#isAppended) {
      return
    }

    if (Modal.existing.length === 0) {
      this.#element.remove()
      this.#isAppended = false
    }
  }

  loading (isLoading) {
    const el = this.#getElement()
    el.classList[isLoading ? 'add' : 'remove'](CLASS_NAME_LOADING)
  }

  #getElement () {
    if (!this.#element) {
      const backdrop = document.createElement('div')
      backdrop.className = this.#config.className
      if (this.#config.isAnimated) {
        backdrop.classList.add(CLASS_NAME_FADE)
      }

      this.#element = backdrop
    }

    return this.#element
  }

  #append () {
    if (this.#isAppended) {
      return
    }

    document.body.append(this.#getElement())

    this.#isAppended = true
  }

  #emulateAnimation (callback) {
    executeAfterTransition(callback, this.#getElement(), this.#config.isAnimated)
  }
}
