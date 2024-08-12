import ConfirmController from './confirm_controller'

import { i18n } from '../core/i18n'

export default class extends ConfirmController {
  static defaultConfirmClass = 'btn-danger'

  get confirmLabel () {
    return this.confirmLabelValue || i18n.t('trestle.confirmation.delete', { defaultValue: 'Delete' })
  }
}
