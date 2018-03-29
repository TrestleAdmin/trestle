Trestle.localize = function() {
  for (var i = 0; i < arguments.length; ++i) {
    var locale = arguments[i];

    if (flatpickr.l10ns[locale]) {
      flatpickr.localize(flatpickr.l10ns[locale]);
      break;
    }
  }
};
