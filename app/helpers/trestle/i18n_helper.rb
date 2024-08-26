module Trestle
  # [Internal]
  module I18nHelper
    FLATPICKR_LOCALE_CONVERSIONS = { ca: "cat", el: "gr", nb: "no", vi: "vn" }.stringify_keys

    # Returns the I18n fallbacks for the given locale.
    #
    # This is used to determine which locale files to include.
    #
    # Examples
    #
    #   i18n_fallbacks("pt-BR") => ["pt-BR", "pt"]
    #   i18n_fallbacks("ca") => ["ca", "es-ES", "es"] %>
    #
    # Returns an array of locale Strings.
    def i18n_fallbacks(locale=I18n.locale)
      if I18n.respond_to?(:fallbacks)
        I18n.fallbacks[locale].map(&:to_s)
      elsif locale.to_s.include?("-")
        fallback = locale.to_s.split("-").first
        [locale, fallback]
      else
        [locale]
      end
    end

    # Returns a nested hash of I18n key/value pairs for passing to JS.
    def i18n_javascript_translations(keys=Trestle.config.javascript_i18n_keys)
      result = {}

      keys.each do |key|
        if translation = I18n.t(key, default: nil)
          *parts, last = key.split(".")

          # Create nesting from period-separated i18n key
          target = parts.inject(result) { |hash, part|
            hash[part] ||= {}
          }

          target[last] = translation
        end
      end

      result
    end

    # Returns the Flatpickr locale code corresponding to the given locale,
    # as some of their codes are different to the Rails' counterparts.
    def flatpickr_locale(locale)
      FLATPICKR_LOCALE_CONVERSIONS.fetch(locale.to_s) { locale }
    end
  end
end
