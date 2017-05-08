Trestle.ready ->
  $('input[type="date"]').flatpickr
    allowInput: true

  $('input[type="datetime"], input[type="datetime-local"]').flatpickr
    enableTime: true
    allowInput: true

  $('input[type="time"]').flatpickr
    enableTime: true
    noCalendar: true
    allowInput: true
