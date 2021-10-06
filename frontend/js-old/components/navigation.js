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

class Navigation {
  constructor () {
    this.store = new NavigationCookieStore()
  }

  toggle (list) {
    if (list.hasClass('collapsed')) {
      this.expand(list)
    } else {
      this.collapse(list)
    }
  }

  expand (list) {
    list.removeClass('collapsed')

    const id = list.data('group')

    this.store.addGroup(id, 'expanded')
    this.store.removeGroup(id, 'collapsed')
  }

  collapse (list) {
    list.addClass('collapsed')

    const id = list.data('group')

    this.store.addGroup(id, 'collapsed')
    this.store.removeGroup(id, 'expanded')
  }
}

export default new Navigation()
