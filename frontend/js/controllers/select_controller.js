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

    $(this.element).on('change.select2', (e) => {
      if (!e.originalEvent) {
        e.preventDefault()

        const nativeEvent = new CustomEvent('change', {
          bubbles: true,
          cancelable: true
        })

        e.target.dispatchEvent(nativeEvent)
      }
    })
  }

  disconnect () {
    $(this.element).select2('destroy')
    $(this.element).off('change.select2')
  }

  get options () {
    return {
      dropdownParent: this.dropdownParent
    }
  }

  get dropdownParent () {
    return this.element.closest('.modal')
  }
}
