require "active_model/naming"

module Trestle
  class ModelName
    attr_reader :klass

    delegate :downcase, :upcase, :titleize, :titlecase, to: :to_s

    def initialize(klass)
      @klass = klass
      @name = klass.respond_to?(:model_name) ? klass.model_name : ActiveModel::Name.new(klass)
    end

    def ==(other)
      other.is_a?(self.class) && klass == other.klass
    end

    def to_s
      singular
    end

    def singular(options={})
      human(default_singular, options)
    end
    alias_method :singularize, :singular

    def plural(options={})
      if i18n_supported? && i18n_pluralizations_available?
        human(default_plural, { count: :many }.merge(options))
      else
        default_plural
      end
    end
    alias_method :pluralize, :plural

  protected
    # Default singular version if it cannot be determined from i18n
    def default_singular
      @name.name.demodulize.titleize
    end

    # Default plural version if it cannot be determined from i18n
    def default_plural
      singular.pluralize(I18n.locale)
    end

    # Safely delegates to ActiveModel::Name#human, catching exceptions caused by missing pluralizations
    def human(default, options={})
      @name.human(options.merge(default: default))
    rescue I18n::InvalidPluralizationData
      default
    end

    # Checks if the model can be translated by ActiveModel
    def i18n_supported?
      klass.respond_to?(:lookup_ancestors) && klass.respond_to?(:i18n_scope)
    end

    # Checks if multiple pluralization forms (e.g. zero/one/few/many/other) are available from i18n
    def i18n_pluralizations_available?
      @name.human(count: nil).is_a?(Hash)
    end
  end
end
