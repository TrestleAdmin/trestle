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
  end
end
