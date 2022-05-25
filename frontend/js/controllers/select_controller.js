import ApplicationController from './application_controller'

import $ from 'jquery'
import 'select2/dist/js/select2.full'

// Use Bootstrap theme
$.fn.select2.defaults.set('theme', 'bootstrap-5')

// Copy all classes from select tag to replacement select field (.select2-selection)
$.fn.select2.defaults.set('containerCssClass', ':all:')

// Copy all classes excluding 'form-control'/'form-control-*'/'form-select'/'form-select-*' from select tag to dropdown container (.select2-dropdown)
$.fn.select2.defaults.set('dropdownCssClass', function (el) {
  return el[0].className.replace(/\s*form-(control|select)(-\w+)?\s*/g, '')
})

export default class extends ApplicationController {
  connect () {
    $(this.element).select2(this.options)
  }

  disconnect () {
    $(this.element).select2('destroy')
  }

  get options () {
    return {}
  }
}
