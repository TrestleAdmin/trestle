import { Controller } from '@hotwired/stimulus'

import cookie from '../core/cookie'

const PREFIX = 'trestle:navigation'
const SEPARATOR = ','

class NavigationCookieStore {
  addGroup (id, state) {
    this.updateState(state, (groups) => groups.add(id))
  }

  removeGroup (id, state) {
    this.updateState(state, (groups) => groups.delete(id))
  }

  updateState (state, callback) {
    const groups = this.getState(state)
    callback(groups)
    this.saveState(state, groups)
  }

  getState (state) {
    const str = cookie.get(`${PREFIX}:${state}`)
    return new Set(str.length ? str.split(SEPARATOR) : [])
  }

  saveState (state, groups) {
    cookie.set(`${PREFIX}:${state}`, [...groups].join(SEPARATOR))
  }
}

export default class extends Controller {
  initialize () {
    this.store = new NavigationCookieStore()
  }

  toggle (e) {
    e.preventDefault()

    const list = e.target.closest('ul')

    if (list.classList.contains('collapsed')) {
      this.expand(list)
    } else {
      this.collapse(list)
    }
  }

  expand (list) {
    list.classList.remove('collapsed')

    const id = list.dataset.group

    this.store.addGroup(id, 'expanded')
    this.store.removeGroup(id, 'collapsed')
  }

  collapse (list) {
    list.classList.add('collapsed')

    const id = list.dataset.group

    this.store.addGroup(id, 'collapsed')
    this.store.removeGroup(id, 'expanded')
  }
}
