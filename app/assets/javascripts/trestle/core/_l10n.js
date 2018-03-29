(function() {

// Some of Flatpickr's locale names differ from Rails. This maps the Rails I18n locale to their Flatpickr equivalent.
var FlatpickrLocaleConversions = { ca: "cat", el: "gr", nb: "no", vi: "vn" };

// Sets up localization for Trestle and its dependencies, in particular Flatpickr.
// This method accepts a list of locales in descending order of priority.
//
//     Trestle.localize('es-MX', 'es', 'en');
//
Trestle.localize = function() {
  for (var i = 0; i < arguments.length; ++i) {
    var locale = arguments[i];
    var flatpickrLocale = FlatpickrLocaleConversions[locale] || locale;

    if (flatpickr.l10ns[flatpickrLocale]) {
      flatpickr.localize(flatpickr.l10ns[flatpickrLocale]);
      break;
    }
  }
};

})();
