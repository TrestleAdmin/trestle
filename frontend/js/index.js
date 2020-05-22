// Dependencies

import 'jquery'
import Rails from '@rails/ujs'

import 'bootstrap'
import 'bootstrap-confirmation2'

import 'magnific-popup'

import 'flatpickr'

import 'select2/dist/js/select2.full'

// Core

import { refreshContext, refreshMainContext } from './core/contexts'
import cookie from './core/cookie'
import { init, ready, triggerInit, triggerReady } from './core/events'
import { i18n, localize } from './core/i18n'
import turbolinks from './core/turbolinks'
import visit from './core/visit'

// Components

import './components/confirmation'
import './components/datepicker'
import Dialog from './components/dialog'
import './components/file'
import './components/form'
import './components/gallery'
import './components/pagination'
import './components/select'
import './components/sidebar'
import './components/table'
import { focusTab, focusActiveTab } from './components/tabs'
import './components/tooltips'

// Initialize

Rails.start()

// Export

const Trestle = {
  refreshContext,
  refreshMainContext,
  cookie,
  init,
  ready,
  triggerInit,
  triggerReady,
  i18n,
  localize,
  turbolinks,
  visit,
  Dialog,
  focusTab,
  focusActiveTab
}

export default Trestle
