module Trestle
  class Scopes
    require_relative "scopes/block"
    require_relative "scopes/definition"
    require_relative "scopes/scope"

    include Enumerable

    delegate :options, to: :@definition

    def initialize(definition, context)
      @definition = definition
      @scopes = @definition.evaluate(context)
    end

    def classes
      [
        'scopes',
        ('grouped' if grouped?),
        layout_class,
        options[:class]
      ].compact
    end

    def each(&block)
      @scopes.values.each(&block)
    end

    def grouped?
      options[:group] != false && any?(&:group)
    end

    def grouped
      if grouped?
        group_by(&:group)
      else
        { nil => @scopes.values.flatten }
      end
    end

    def active(params)
      select { |s| s.active?(params) }
    end

  private
    def layout_class
      "columns" if %w(column columns).include?(options[:layout].to_s)
    end
  end
end
