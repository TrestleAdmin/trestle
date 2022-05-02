/* global history, location */

import ApplicationController from './application_controller'

import { navigator } from '@hotwired/turbo'
import { Tab } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    this.element.querySelectorAll('.nav-link').forEach((link) => {
      link.addEventListener('shown.bs.tab', this.saveActiveTab)
    })

    this.focusActiveTab()
  }

  disconnect () {
    this.element.querySelectorAll('.nav-link').forEach((link) => {
      link.removeEventListener('shown.bs.tab', this.saveActiveTab)
    })
  }

  saveActiveTab (e) {
    const hash = e.target.getAttribute('href')

    if (hash.substring(0, 1) === '#') {
      const url = `${location.pathname}#!${hash.substring(1)}`

      history.replaceState({}, null, url)
      navigator.history.replace(new URL(url, location.origin))
    }
  }

  focusActiveTab () {
    if (location.hash.substring(0, 2) === '#!') {
      const hash = location.hash.substring(2)
      const link = this.element.querySelector(`.nav-link[href='#${hash}']`)

      if (link) {
        const tab = new Tab(link)
        tab.show()
      }
    }
  }
}
