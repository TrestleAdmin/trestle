import FlatpickrController from './flatpickr_controller'

import { i18n } from '../core/i18n'

export default class extends FlatpickrController {
  get options () {
    return {
      ...super.options,
      enableTime: true,
      altFormat: i18n['admin.datepicker.formats.datetime'] || 'm/d/Y h:i K'
    }
  }
}
