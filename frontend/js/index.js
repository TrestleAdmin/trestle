// Dependencies

import '@hotwired/turbo'

import 'bootstrap'

// Core

import cookie from './core/cookie'
import { i18n, localize } from './core/i18n'
import './core/compatibility'

// Stimulus controllers

import './controllers'

// Export

const Trestle = {
  cookie,
  i18n,
  localize
}

export default Trestle
