import $ from 'jquery'

import { init } from '../core/events'
import { i18n } from '../core/i18n'

init(function (root) {
  const DEFAULTS = {
    singleton: true,
    popout: true,
    title: i18n['trestle.confirmation.title'] || 'Are you sure?',
    btnOkClass: 'btn-primary',
    btnOkLabel: i18n['trestle.confirmation.ok'] || 'OK',
    btnCancelClass: 'btn-light',
    btnCancelLabel: i18n['trestle.confirmation.cancel'] || 'Cancel',
    copyAttributes: ''
  }

  const CONFIRM = { ...DEFAULTS,
    rootSelector: '[data-toggle="confirm"]'
  }

  const DELETE = { ...DEFAULTS,
    rootSelector: '[data-toggle="confirm-delete"]',
    btnOkClass: 'btn-danger',
    btnOkLabel: i18n['trestle.confirmation.delete'] || 'Delete'
  }

  $(root).find('[data-toggle="confirm"]').confirmation(CONFIRM)
  $(root).find('[data-toggle="confirm-delete"]').confirmation(DELETE)
})
