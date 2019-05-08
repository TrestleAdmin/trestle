import $ from 'jquery'

import { init } from '../core/events'

// Use Bootstrap theme
$.fn.select2.defaults.set('theme', 'bootstrap')

// Copy all classes from select tag to replacement select field (.select2-selection)
$.fn.select2.defaults.set('containerCssClass', ':all:')

// Copy all classes excluding 'form-control'/'form-control-*' from select tag to dropdown container (.select2-dropdown)
$.fn.select2.defaults.set('dropdownCssClass', function (el) {
  return el[0].className.replace(/\s*form-control(-\w+)?\s*/g, '')
})

init(function (root) {
  $(root).find('select[data-enable-select2]').select2()
})
