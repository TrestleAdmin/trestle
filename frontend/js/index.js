// Global Dependencies

import '@hotwired/turbo'
import 'bootstrap'

// Core Functionality

import './core/stream_actions'

import cookie from './core/cookie'
import { i18n, localize } from './core/i18n'

import Modal from './core/modal'
import ErrorModal from './core/error_modal'

// Stimulus Controllers

import { ApplicationController, Controllers } from './controllers'

// Deprecated Functionality

import { init, ready, triggerInit, triggerReady } from './deprecated/events'
import './deprecated/tooltip'

// Export

const Trestle = {
  cookie,
  i18n,
  localize,

  // Stimulus
  ApplicationController,
  Controllers,

  // Modals
  Modal,
  ErrorModal,

  // Deprecated
  init,
  ready,
  triggerInit,
  triggerReady
}

export default Trestle
