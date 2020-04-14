import $ from 'jquery'

import { init } from '../core/events'
import { i18n } from '../core/i18n'

init(function (root) {
  const DEFAULTS = {
    singleton: true,
    popout: true,
    title: i18n['trestle.confirmation.title'] || 'Are you sure?',
    btnOkClass: 'btn btn-sm btn-primary',
    btnOkLabel: i18n['trestle.confirmation.ok'] || 'OK',
    btnCancelClass: 'btn btn-sm btn-light',
    btnCancelLabel: i18n['trestle.confirmation.cancel'] || 'Cancel',
    copyAttributes: 'href target data-remote data-method data-url data-params data-type'
  }

  const CONFIRM = {
    ...DEFAULTS,
    rootSelector: '[data-toggle="confirm"]'
  }

  const DELETE = {
    ...DEFAULTS,
    rootSelector: '[data-toggle="confirm-delete"]',
    btnOkClass: 'btn btn-sm btn-danger',
    btnOkLabel: i18n['trestle.confirmation.delete'] || 'Delete'
  }

  $(root).find('[data-toggle="confirm"]').confirmation(CONFIRM)
  $(root).find('[data-toggle="confirm-delete"]').confirmation(DELETE)
})
