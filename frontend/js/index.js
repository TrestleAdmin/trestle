// Global Dependencies

import '@hotwired/turbo'
import 'bootstrap'

// Core Functionality

import cookie from './core/cookie'
import { i18n, localize } from './core/i18n'

// Stimulus Controllers

import { ApplicationController, Controllers } from './controllers'

// Deprecated Functionality

import { init, ready, triggerInit, triggerReady } from './deprecated/events'
import './deprecated/tooltip'
import './deprecated/popover'

// Export

const Trestle = {
  cookie,
  i18n,
  localize,

  // Stimulus
  ApplicationController,
  Controllers,

  // Deprecated
  init,
  ready,
  triggerInit,
  triggerReady
}

export default Trestle
