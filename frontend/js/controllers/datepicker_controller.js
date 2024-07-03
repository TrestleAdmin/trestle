import FlatpickrController from './flatpickr_controller'

import { i18n } from '../core/i18n'

export default class extends FlatpickrController {
  get options () {
    return {
      ...super.options,
      altFormat: i18n.t('admin.datepicker.formats.date', { defaultValue: 'm/d/Y' })
    }
  }
}
