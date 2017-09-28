Trestle.init(function(e, root) {
  $(root).find('input[type="date"][data-picker="true"]').flatpickr({
    allowInput: true,
    altInput:   true,
    altFormat:  "m/d/Y",
  });

  $(root).find('input[type="datetime"][data-picker="true"], input[type="datetime-local"][data-picker="true"]').flatpickr({
    enableTime: true,
    allowInput: true,
    altInput:   true,
    altFormat:  "m/d/Y h:i K",
  });

  $(root).find('input[type="time"][data-picker="true"]').flatpickr({
    enableTime: true,
    noCalendar: true,
    allowInput: true,
    altInput:   true,
    altFormat:  "h:i K"
  });
});
