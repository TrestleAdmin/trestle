module Trestle
  module I18nHelper
    def i18n_fallbacks(locale=I18n.locale)
      if I18n.respond_to?(:fallbacks)
        I18n.fallbacks[locale]
      elsif locale.to_s.include?("-")
        fallback = locale.to_s.split("-").first
        [locale, fallback]
      else
        [locale]
      end
    end

    def default_translation(key)
      translate(key, locale: :en)
    rescue I18n::InvalidLocale
      key.split(".").last.humanize
    end
  end
end
