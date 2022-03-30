import ConfirmController from './confirm_controller'

import { i18n } from '../core/i18n'

export default class extends ConfirmController {
  static values = {
    confirmLabel: i18n['trestle.confirmation.delete'] || 'Delete'
  }

  static defaultConfirmClass = 'btn-danger'
}
