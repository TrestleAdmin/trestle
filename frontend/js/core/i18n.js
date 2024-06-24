import { I18n } from 'i18n-js'
import flatpickr from 'flatpickr'

// Container for i18n translations
export const i18n = new I18n()

function localizeTrestle (locale, fallbacks) {
  // Set up i18n fallbacks
  i18n.enableFallback = true
  i18n.locales.register(locale, [locale, ...fallbacks])

  // Set current locale
  i18n.locale = locale
}

// Some of Flatpickr's locale names differ from Rails. This maps the Rails I18n locale to their Flatpickr equivalent.
const FlatpickrLocaleConversions = { ca: 'cat', el: 'gr', nb: 'no', vi: 'vn' }

function localizeFlatpickr (...locales) {
  for (const locale of locales) {
    const flatpickrLocale = FlatpickrLocaleConversions[locale] || locale

    if (flatpickr.l10ns[flatpickrLocale]) {
      flatpickr.localize(flatpickr.l10ns[flatpickrLocale])
      break
    }
  }
}

// Sets up localization for Trestle and its dependencies, in particular Flatpickr.
// This method accepts a list of locales in descending order of priority.
//
//     Trestle.localize('es-MX', 'es', 'en')
//
export function localize (locale, ...fallbacks) {
  localizeTrestle(locale, fallbacks)
  localizeFlatpickr(locale, ...fallbacks)
}
