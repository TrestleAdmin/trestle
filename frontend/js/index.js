// Dependencies

import '@hotwired/turbo'

import 'bootstrap'

// Stimulus controllers

import './controllers'

// Core

import cookie from './core/cookie'
import { i18n, localize } from './core/i18n'

// Export

const Trestle = {
  cookie,
  i18n,
  localize
}

export default Trestle
