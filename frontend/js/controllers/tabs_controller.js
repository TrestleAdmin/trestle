/* global history, location */

import { Controller } from '@hotwired/stimulus'

import { Tab } from 'bootstrap'

export default class extends Controller {
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
    const url = e.target.getAttribute('href')

    if (url.substring(0, 1) === '#') {
      history.replaceState({}, '', `#!${url.substring(1)}`)
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
