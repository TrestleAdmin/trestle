import $ from 'jquery'

import { init } from '../core/events'
import { i18n } from '../core/i18n'

function setupDatePicker (selectedDates, dateStr, instance) {
  addClearButton(instance)
  enableDirectEntry(instance)
}

function addClearButton (instance) {
  const $input = $(instance.input)

  if ($input.data('allow-clear')) {
    $('<a href="#">')
      .on('click', function (e) {
        e.preventDefault()

        const isDisabled = $input.is(':disabled') || $input.hasClass('disabled')

        if (!isDisabled) {
          instance.clear()
        }
      })
      .addClass('clear-datepicker')
      .insertBefore(instance.altInput)
  }
}

function enableDirectEntry (instance) {
  const $altInput = $(instance.altInput)

  $altInput.on('input', function (e) {
    const value = $altInput.val()

    const parsedDate = instance.parseDate(value, instance.config.altFormat)
    const formattedDate = instance.formatDate(parsedDate, instance.config.altFormat)

    if (value === formattedDate) {
      instance.setDate(value, true, instance.config.altFormat)
    }
  })
}

init(function (root) {
  $(root).find('input[type="date"][data-picker="true"]').flatpickr({
    allowInput: true,
    altInput: true,
    altFormat: i18n['admin.datepicker.formats.date'] || 'm/d/Y',
    onReady: setupDatePicker
  })

  $(root).find('input[type="datetime"][data-picker="true"], input[type="datetime-local"][data-picker="true"]').flatpickr({
    enableTime: true,
    allowInput: true,
    altInput: true,
    altFormat: i18n['admin.datepicker.formats.datetime'] || 'm/d/Y h:i K',
    onReady: setupDatePicker
  })

  $(root).find('input[type="time"][data-picker="true"]').flatpickr({
    enableTime: true,
    noCalendar: true,
    allowInput: true,
    altInput: true,
    altFormat: i18n['admin.datepicker.formats.time'] || 'h:i K',
    onReady: setupDatePicker
  })
})
