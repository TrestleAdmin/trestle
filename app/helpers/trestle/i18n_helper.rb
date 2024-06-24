module Trestle
  module I18nHelper
    FLATPICKR_LOCALE_CONVERSIONS = { ca: "cat", el: "gr", nb: "no", vi: "vn" }.stringify_keys

    def i18n_javascript_translations
      Trestle.config.javascript_i18n_keys.map { |key|
        begin
          [key, t(key, raise: true)]
        rescue I18n::MissingTranslationData
          nil
        end
      }.compact
    end

    def flatpickr_locale(locale)
      FLATPICKR_LOCALE_CONVERSIONS.fetch(locale.to_s) { locale }
    end
  end
end
