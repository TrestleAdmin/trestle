require "active_model/naming"

module Trestle
  class ModelName
    attr_reader :klass

    delegate :downcase, :upcase, :titleize, :titlecase, to: :to_s

    def initialize(klass)
      @klass = klass

      if klass.respond_to?(:model_name)
        @name = klass.model_name
      else
        @name = ActiveModel::Name.new(klass)
      end
    end

    def ==(other)
      other.is_a?(self.class) && klass == other.klass
    end

    def to_s
      human
    end

    def singular(options={})
      human(options)
    end
    alias_method :singularize, :singular

    def plural(options={})
      if klass.respond_to?(:lookup_ancestors) && klass.respond_to?(:i18n_scope)
        human({ count: :many, default: human.pluralize }.merge(options))
      else
        human.pluralize
      end
    end
    alias_method :pluralize, :plural

    def human(options={})
      @name.human(options)
    end
  end
end
