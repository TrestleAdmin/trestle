module Trestle
  module I18nHelper
    def i18n_javascript_translations
      Trestle.config.javascript_i18n_keys.map { |key|
        begin
          [key, t(key, raise: true)]
        rescue I18n::MissingTranslationData
          nil
        end
      }.compact
    end
  end
end
